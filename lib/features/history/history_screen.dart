import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import 'package:intl/intl.dart';

/// History screen showing recent scans and activity
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isDark = state.isDarkMode;
    final recentDocs = state.recentDocuments;

    return Column(
      children: [
        // App bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scan History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppTheme.getTextPrimary(isDark),
                ),
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

        // Content
        Expanded(
          child: recentDocs.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recentDocs.length,
                  itemBuilder: (context, index) {
                    final doc = recentDocs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: AppTheme.glassCard(isDark),
                        child: Row(
                          children: [
                            // Time indicator
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
                            
                            // Arrow
                            Icon(
                              LucideIcons.chevronRight,
                              color: AppTheme.getTextMuted(isDark),
                              size: 18,
                            ),
                          ],
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
              color: AppTheme.getSurfaceColor(isDark),
              border: Border.all(color: AppTheme.getBorderColor(isDark)),
            ),
            child: Icon(
              LucideIcons.clock,
              size: 64,
              color: AppTheme.getTextMuted(isDark),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No scan history yet',
            style: TextStyle(
              color: AppTheme.getTextPrimary(isDark),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent scans will appear here',
            style: TextStyle(
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
