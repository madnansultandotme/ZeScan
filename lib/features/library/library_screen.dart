import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/models/document.dart';
import '../../core/state/app_state.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/file_manager_service.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  IconData _getFolderIcon(String key) {
    switch (key) {
      case 'files':
        return LucideIcons.files;
      case 'bookOpen':
        return LucideIcons.bookOpen;
      case 'receipt':
        return LucideIcons.receipt;
      case 'user':
        return LucideIcons.user;
      case 'briefcase':
        return LucideIcons.briefcase;
      default:
        return LucideIcons.folder;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final files = state.filteredDocuments;
    final recents = state.recentDocuments;
    final isDark = state.isDarkMode;

    return Column(
      children: [
        // App bar & Privacy badge
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppTheme.getIcon(isDark),
                    height: 32,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(LucideIcons.scan, color: AppTheme.primaryLight, size: 32),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ZeScan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppTheme.getTextPrimary(isDark),
                    ),
                  ),
                ],
              ),
              // Privacy Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.privacyGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.shieldCheck, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Privacy First',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.getSurfaceColor(isDark),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.getBorderColor(isDark), width: 1),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => state.setSearchQuery(value),
              style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: Icon(LucideIcons.search, color: AppTheme.getTextSecondary(isDark), size: 18),
                hintText: 'Search documents...',
                hintStyle: TextStyle(color: AppTheme.getTextMuted(isDark), fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(LucideIcons.x, color: AppTheme.getTextSecondary(isDark), size: 16),
                        onPressed: () {
                          _searchController.clear();
                          state.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),

        // Expanded view content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            children: [
              // Folders horizontal list
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.folders.length,
                  itemBuilder: (context, index) {
                    final folder = state.folders[index];
                    final isSelected = state.selectedFolderId == folder.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => state.selectFolder(folder.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGlow : AppTheme.getSurfaceColor(isDark),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryLight : AppTheme.getBorderColor(isDark),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getFolderIcon(folder.iconKey),
                                color: isSelected ? AppTheme.primaryLight : AppTheme.getTextSecondary(isDark),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                folder.name,
                                style: TextStyle(
                                  color: isSelected ? (isDark ? Colors.white : AppTheme.primary) : AppTheme.getTextSecondary(isDark),
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Recent Documents Section
              if (recents.isNotEmpty && state.searchQuery.isEmpty && state.selectedFolderId == 'all') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    'Recent Scans',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: recents.length,
                    itemBuilder: (context, index) {
                      final doc = recents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () => _showDocumentActions(context, doc, state),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(10),
                            decoration: AppTheme.glassCard(isDark),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(LucideIcons.fileText, color: AppTheme.primaryLight, size: 24),
                                    if (doc.isFavorite)
                                      const Icon(LucideIcons.star, color: AppTheme.warning, size: 14),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppTheme.getTextPrimary(isDark),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${doc.pages.length} pgs • ${doc.sizeInMb}MB',
                                      style: TextStyle(
                                        color: AppTheme.getTextSecondary(isDark),
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Files Library Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedFolderId == 'all' ? 'All Files' : 'Files in Folder',
                      style: TextStyle(
                        color: AppTheme.getTextPrimary(isDark),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${files.length} items',
                      style: TextStyle(
                        color: AppTheme.getTextSecondary(isDark),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Files list
              if (files.isEmpty)
                _buildEmptyState(state)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final doc = files[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () => _showDocumentActions(context, doc, state),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: AppTheme.glassCard(isDark),
                          child: Row(
                            children: [
                              // Doc Type Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppTheme.getBackgroundColor(isDark),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(LucideIcons.fileText, color: AppTheme.primaryLight),
                              ),
                              const SizedBox(width: 12),
                              // Doc Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppTheme.getTextPrimary(isDark),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd, yyyy • hh:mm a').format(doc.createdAt),
                                          style: TextStyle(
                                            color: AppTheme.getTextSecondary(isDark),
                                            fontSize: 10,
                                          ),
                                        ),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: AppTheme.getTextSecondary(isDark),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(
                                          '${doc.pages.length} pgs • ${doc.sizeInMb} MB',
                                          style: TextStyle(
                                            color: AppTheme.getTextSecondary(isDark),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Star indicator
                              IconButton(
                                icon: Icon(
                                  doc.isFavorite ? LucideIcons.star : LucideIcons.star,
                                  color: doc.isFavorite ? AppTheme.warning : AppTheme.getTextMuted(isDark),
                                  size: 18,
                                ),
                                onPressed: () => state.toggleFavorite(doc.id),
                              ),
                              // Actions menu trigger
                              IconButton(
                                icon: Icon(LucideIcons.moreVertical, color: AppTheme.getTextSecondary(isDark), size: 18),
                                onPressed: () => _showDocumentActions(context, doc, state),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppState state) {
    final hasSearch = state.searchQuery.isNotEmpty;
    final illustration = hasSearch
        ? 'assets/illustrations/undraw_not-found_6bgl.svg'
        : 'assets/illustrations/undraw_empty_4zx0.svg';
    final message = hasSearch
        ? 'No matching files found'
        : 'Your library is empty.\nTap Quick Scan to create a document!';

    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            illustration,
            height: 140,
            placeholderBuilder: (context) => Container(
              height: 140,
              alignment: Alignment.center,
              child: const Icon(LucideIcons.files, size: 64, color: AppTheme.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.getTextSecondary(state.isDarkMode),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentActions(BuildContext context, Document doc, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Icon(LucideIcons.fileText, color: AppTheme.primaryLight, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${doc.pages.length} pages • ${doc.sizeInMb} MB',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: AppTheme.borderDark, height: 24),

              // Action buttons
              _buildActionItem(
                icon: LucideIcons.eye,
                label: 'Open PDF',
                onTap: () async {
                  Navigator.pop(context);
                  
                  if (doc.pdfPath == null || doc.pdfPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PDF file not found'),
                        backgroundColor: AppTheme.danger,
                      ),
                    );
                    return;
                  }
                  
                  // Check if file exists
                  final exists = await FileManagerService.pdfExists(doc.pdfPath);
                  if (!exists) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF file not found on disk'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    }
                    return;
                  }
                  
                  // Open in built-in PDF viewer
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          pdfPath: doc.pdfPath!,
                          documentName: doc.name,
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildActionItem(
                icon: LucideIcons.share2,
                label: 'Share PDF',
                onTap: () async {
                  Navigator.pop(context);
                  
                  try {
                    if (doc.pdfPath == null || doc.pdfPath!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF file not found'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }
                    
                    await FileManagerService.sharePdf(doc.pdfPath, doc.name);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to share: ${e.toString()}'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    }
                  }
                },
              ),
              _buildActionItem(
                icon: LucideIcons.star,
                label: doc.isFavorite ? 'Unfavorite' : 'Favorite',
                iconColor: doc.isFavorite ? AppTheme.warning : null,
                onTap: () {
                  Navigator.pop(context);
                  state.toggleFavorite(doc.id);
                },
              ),
              _buildActionItem(
                icon: LucideIcons.edit3,
                label: 'Rename File',
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(context, doc, state);
                },
              ),
              _buildActionItem(
                icon: LucideIcons.folderInput,
                label: 'Move to Folder',
                onTap: () {
                  Navigator.pop(context);
                  _showMoveDialog(context, doc, state);
                },
              ),
              _buildActionItem(
                icon: LucideIcons.trash2,
                label: 'Delete Document',
                iconColor: AppTheme.danger,
                textColor: AppTheme.danger,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(context, doc, state);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppTheme.textSecondary, size: 20),
      title: Text(
        label,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _showRenameDialog(BuildContext context, Document doc, AppState state) {
    final controller = TextEditingController(text: doc.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text('Rename Document', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new name',
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.borderDark)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryLight)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  state.renameDocument(doc.id, controller.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: AppTheme.primaryLight)),
            ),
          ],
        );
      },
    );
  }

  void _showMoveDialog(BuildContext context, Document doc, AppState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text('Move to Folder', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                final folder = state.folders[index];
                if (folder.id == 'all') return const SizedBox.shrink();
                return ListTile(
                  leading: Icon(_getFolderIcon(folder.iconKey), color: AppTheme.textSecondary, size: 18),
                  title: Text(folder.name, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  trailing: doc.folderId == folder.id ? const Icon(LucideIcons.check, color: AppTheme.success, size: 16) : null,
                  onTap: () {
                    state.moveDocumentToFolder(doc.id, folder.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Document doc, AppState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text('Delete Document', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete "${doc.name}"? This action cannot be undone.', style: const TextStyle(color: AppTheme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                state.deleteDocument(doc.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: AppTheme.danger)),
            ),
          ],
        );
      },
    );
  }
}
