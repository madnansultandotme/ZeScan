import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/models/document.dart';

class ShareScreen extends StatelessWidget {
  final Document document;

  const ShareScreen({super.key, required this.document});

  void _sharePDF(BuildContext context, String platformName) {
    // Share the real PDF file from disk if available
    if (document.pdfPath != null && File(document.pdfPath!).existsSync()) {
      Share.shareXFiles(
        [XFile(document.pdfPath!)],
        text: '${document.name}.pdf — Created with ZeScan',
      );
    } else {
      // Fallback: trigger native share with intent
      Share.share(
        'PDF: ${document.name}.pdf (${document.sizeInMb} MB, ${document.pages.length} pages) — Created with ZeScan',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing via $platformName...'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Animated check circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success.withOpacity(0.15),
                  border: Border.all(color: AppTheme.success, width: 2),
                ),
                child: const Icon(
                  LucideIcons.check,
                  color: AppTheme.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'PDF Rendered Successfully',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your documents are processed securely and privately.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              
              const SizedBox(height: 32),

              // File summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.fileText, color: AppTheme.primaryLight, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${document.name}.pdf',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${document.pages.length} pages • ${document.sizeInMb} MB',
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.borderDark, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date Created', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                        Text(
                          DateFormat('MMM dd, yyyy • hh:mm a').format(document.createdAt),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (document.pdfPath != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Storage', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                          Row(
                            children: [
                              const Icon(LucideIcons.hardDrive, color: AppTheme.success, size: 12),
                              const SizedBox(width: 4),
                              const Text(
                                'Saved on device',
                                style: TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),

              // Quick share label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Share Attachments',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Share apps grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShareIcon(context, LucideIcons.messageCircle, 'WhatsApp', const Color(0xFF25D366)),
                  _buildShareIcon(context, LucideIcons.mail, 'Gmail', const Color(0xFFEA4335)),
                  _buildShareIcon(context, LucideIcons.hardDrive, 'Drive', const Color(0xFF4285F4)),
                  _buildShareIcon(context, LucideIcons.send, 'Telegram', const Color(0xFF0088CC)),
                  _buildShareIcon(context, LucideIcons.share2, 'More', AppTheme.primaryLight),
                ],
              ),

              const Spacer(),

              // Done back button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate back to library root
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.borderDark, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    'Back to Library',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareIcon(BuildContext context, IconData icon, String name, Color color) {
    return GestureDetector(
      onTap: () => _sharePDF(context, name),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
              border: Border.all(color: color.withOpacity(0.4), width: 1),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
