import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/models/document.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/file_manager_service.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

/// Favorites screen showing starred/favorite documents
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isDark = state.isDarkMode;
    final favoriteDocs = state.favoriteDocuments;

    return Column(
      children: [
        // App bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.star, color: AppTheme.warning, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppTheme.getTextPrimary(isDark),
                    ),
                  ),
                ],
              ),
              // Count badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: Text(
                  '${favoriteDocs.length} ${favoriteDocs.length == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    color: AppTheme.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: favoriteDocs.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    final doc = favoriteDocs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () => _showDocumentActions(context, doc, state),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: AppTheme.glassCard(isDark),
                          child: Row(
                            children: [
                              // Doc icon with star badge
                              Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppTheme.getBackgroundColor(isDark),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      LucideIcons.fileText,
                                      color: AppTheme.primaryLight,
                                      size: 24,
                                    ),
                                  ),
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.warning,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.getBackgroundColor(isDark),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              
                              // Doc info
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM dd, yyyy • hh:mm a').format(doc.createdAt),
                                      style: TextStyle(
                                        color: AppTheme.getTextSecondary(isDark),
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${doc.pages.length} pages • ${doc.sizeInMb} MB',
                                      style: TextStyle(
                                        color: AppTheme.getTextMuted(isDark),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // More options
                              IconButton(
                                icon: Icon(
                                  LucideIcons.moreVertical,
                                  color: AppTheme.getTextSecondary(isDark),
                                  size: 18,
                                ),
                                onPressed: () => _showDocumentActions(context, doc, state),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.warning.withOpacity(0.1),
              border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
            ),
            child: const Icon(
              LucideIcons.star,
              size: 64,
              color: AppTheme.warning,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: TextStyle(
              color: AppTheme.getTextPrimary(isDark),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Star your important documents to quickly find them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.getTextSecondary(isDark),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentActions(BuildContext context, Document doc, state) {
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
                      const SnackBar(content: Text('PDF file not found'), backgroundColor: AppTheme.danger),
                    );
                    return;
                  }
                  
                  // Check if file exists
                  final exists = await FileManagerService.pdfExists(doc.pdfPath);
                  if (!exists) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PDF file not found on disk'), backgroundColor: AppTheme.danger),
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
                    await FileManagerService.sharePdf(doc.pdfPath, doc.name);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to share: $e'), backgroundColor: AppTheme.danger),
                      );
                    }
                  }
                },
              ),
              _buildActionItem(
                icon: LucideIcons.star,
                label: 'Remove from Favorites',
                iconColor: AppTheme.warning,
                textColor: AppTheme.warning,
                onTap: () {
                  Navigator.pop(context);
                  state.toggleFavorite(doc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
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
}
