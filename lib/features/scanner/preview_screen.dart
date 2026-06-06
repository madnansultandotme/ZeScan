import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/document_scanner_service.dart';
import 'scanner_screen.dart';
import 'export_sheet.dart';
import 'image_editor_screen.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int _selectedPageIndex = 0;

  void _showPageOptionsSheet(BuildContext context, int index, String path) {
    final state = AppStateProvider.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page ${index + 1} Actions',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(color: AppTheme.borderDark, height: 24),
              ListTile(
                leading: const Icon(LucideIcons.crop, color: AppTheme.primaryLight),
                title: const Text('Edit (Crop & Rotate)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _openImageEditor(context, index, path);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.camera, color: AppTheme.textSecondary),
                title: const Text('Retake Page (Camera)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pop(context); // Go back to scanner
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image, color: AppTheme.textSecondary),
                title: const Text('Replace Page (Gallery)', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  // Request photo permission
                  if (!context.mounted) return;
                  final hasPermission = await PermissionService.requestPhotos(context);
                  if (!hasPermission) return;

                  final picker = ImagePicker();
                  try {
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      state.replacePageInScanQueue(index, image.path);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Replace failed: ${e.toString()}'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: AppTheme.danger),
                title: const Text('Delete Page', style: TextStyle(color: AppTheme.danger)),
                onTap: () {
                  Navigator.pop(context);
                  state.removePageFromScanQueue(index);
                  if (state.scanQueue.isEmpty) {
                    Navigator.pop(context); // Go back if no pages left
                  } else {
                    setState(() {
                      _selectedPageIndex = 0;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Open image editor for manual crop and rotate
  void _openImageEditor(BuildContext context, int index, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditorScreen(
          imagePath: imagePath,
          onSave: (editedPath) async {
            final state = AppStateProvider.of(context);

            // Replace the page in queue with edited version (no enhancement)
            state.replacePageInScanQueue(index, editedPath);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Page updated!'),
                duration: Duration(seconds: 1),
                backgroundColor: AppTheme.success,
              ),
            );

            // Close editor
            Navigator.pop(context);

            // Refresh the view
            setState(() {
              _selectedPageIndex = index;
            });
          },
        ),
      ),
    );
  }

  /// Builds the visual widget for a page. Uses Image.file for real captured
  /// images and SvgPicture.asset for legacy mock assets.
  Widget _buildPageVisual(String path, {BoxFit fit = BoxFit.contain}) {
    // Legacy mock SVG assets
    if (path.startsWith('assets/')) {
      return SvgPicture.asset(
        path,
        fit: fit,
        placeholderBuilder: (context) => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryLight),
        ),
      );
    }

    // Real image file from camera or gallery
    final file = File(path);
    return Image.file(
      file,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.imageOff, color: AppTheme.textMuted, size: 36),
              const SizedBox(height: 8),
              Text(
                'Image not found',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final pages = state.scanQueue;

    if (_selectedPageIndex >= pages.length) {
      _selectedPageIndex = pages.isEmpty ? 0 : pages.length - 1;
    }

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Preview Pages'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          tooltip: 'Back',
          onPressed: () {
            // Go back to scanner
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            tooltip: 'Add more pages',
            onPressed: () {
              // Return to scanner to add more pages
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.x),
            tooltip: 'Cancel & exit',
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surfaceDark,
                  title: const Text('Discard pages?', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'Are you sure you want to discard these pages and return to library?',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final state = AppStateProvider.of(context);
                        state.startNewScan(); // Clear scan queue
                        // Pop dialog, preview, and scanner to return to main shell
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Discard', style: TextStyle(color: AppTheme.danger)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Current Page Viewer
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: pages.isEmpty
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        decoration: AppTheme.glassCard(),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildPageVisual(pages[_selectedPageIndex]),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(LucideIcons.edit3, color: AppTheme.primaryLight),
                                onPressed: () => _showPageOptionsSheet(context, _selectedPageIndex, pages[_selectedPageIndex]),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Page ${_selectedPageIndex + 1} of ${pages.length}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          // Reorderable / Selectable Strip Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Queue (Drag to Reorder)',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Icon(LucideIcons.sliders, color: AppTheme.textSecondary, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Horizontal scroll of thumbnail pages
          Expanded(
            flex: 1,
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                buildDefaultDragHandles: true,
                onReorder: (oldIndex, newIndex) {
                  state.reorderScanQueue(oldIndex, newIndex);
                  setState(() {
                    if (_selectedPageIndex == oldIndex) {
                      _selectedPageIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
                    } else if (_selectedPageIndex > oldIndex && _selectedPageIndex <= newIndex) {
                      _selectedPageIndex--;
                    } else if (_selectedPageIndex < oldIndex && _selectedPageIndex >= newIndex) {
                      _selectedPageIndex++;
                    }
                  });
                },
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.1,
                        child: Material(
                          elevation: 6,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: child,
                        ),
                      );
                    },
                    child: child,
                  );
                },
                children: List.generate(pages.length, (index) {
                  final path = pages[index];
                  final isSelected = _selectedPageIndex == index;
                  // Use index-based key for stable identity during reorder
                  return Container(
                    key: ValueKey('$path-$index'),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryLight : AppTheme.borderDark,
                        width: isSelected ? 2 : 1,
                      ),
                      color: AppTheme.surfaceDark,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPageIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _buildPageVisual(path, fit: BoxFit.cover),
                          ),
                        ),
                        // Page number badge
                        Positioned(
                          top: 2,
                          left: 2,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: AppTheme.primary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Delete button with better visibility
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              state.removePageFromScanQueue(index);
                              if (state.scanQueue.isEmpty) {
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _selectedPageIndex = _selectedPageIndex.clamp(0, state.scanQueue.length - 1);
                                });
                              }
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppTheme.danger,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(LucideIcons.x, color: Colors.white, size: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Export Footer Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ExportSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next: Export PDF',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Icon(LucideIcons.arrowRight, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
