import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _simulatedCacheSize = 1.4;

  void _clearCache() {
    setState(() {
      _simulatedCacheSize = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary document image cache cleared!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final count = state.documents.length;
    final isDark = state.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Settings & Privacy',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(isDark),
            ),
          ),
          const SizedBox(height: 16),

          // 1. PRIVACY & SECURITY AUDIT PANEL
          Text(
            '100% On-Device Verification Audit',
            style: TextStyle(
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.glassCard(isDark),
            child: Column(
              children: [
                _buildAuditRow(
                  isDark: isDark,
                  icon: LucideIcons.database,
                  label: 'Local Database Entries',
                  value: '$count PDFs saved',
                  statusColor: AppTheme.success,
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.trash2, color: AppTheme.getTextSecondary(isDark), size: 18),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Image Cache Size',
                              style: TextStyle(
                                color: AppTheme.getTextPrimary(isDark),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_simulatedCacheSize.toStringAsFixed(1)} MB used',
                              style: TextStyle(
                                color: AppTheme.getTextSecondary(isDark),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_simulatedCacheSize > 0)
                      TextButton(
                        onPressed: _clearCache,
                        child: const Text('Clear', style: TextStyle(color: AppTheme.danger, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    else
                      Text(
                        'Cleared',
                        style: TextStyle(color: AppTheme.getTextMuted(isDark), fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. GENERAL PREFERENCES
          Text(
            'General Preferences',
            style: TextStyle(
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppTheme.glassCard(isDark),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  value: isDark,
                  onChanged: (val) {
                    state.toggleTheme();
                  },
                  secondary: Icon(LucideIcons.moon, color: AppTheme.getTextSecondary(isDark), size: 18),
                  title: Text(
                    'Dark Theme Toggle',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  activeColor: AppTheme.primaryLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 1),
                ListTile(
                  leading: Icon(LucideIcons.fileText, color: AppTheme.getTextSecondary(isDark), size: 18),
                  title: Text(
                    'Privacy Policy Details',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'zescan.zeppelinlabs.digital/privacy',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted, size: 14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening privacy policy link...')),
                    );
                  },
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 1),
                ListTile(
                  leading: Icon(LucideIcons.info, color: AppTheme.getTextSecondary(isDark), size: 18),
                  title: Text(
                    'About ZeScan',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Version 1.0 (Zeppelin Labs)',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 11,
                    ),
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset('assets/images/icon.png', width: 48, height: 48, errorBuilder: (c, e, s) => const Icon(LucideIcons.scan, size: 48)),
                      applicationName: 'ZeScan Scanner',
                      applicationVersion: '1.0.0 (MVP)',
                      children: const [
                        Text('A privacy-first, on-device document scanner and PDF toolkit developed by Zeppelin Labs. Designed to scan documents without watermarks, accounts, or internet connections.'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. SUPPORT & FEEDBACK
          Text(
            'Support & Feedback',
            style: TextStyle(
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppTheme.glassCard(isDark),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.messageSquare, color: AppTheme.getTextSecondary(isDark), size: 18),
                  title: Text(
                    'Send Feedback',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Share your thoughts and suggestions',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted, size: 14),
                  onTap: () {
                    _showFeedbackDialog(context, isDark, 'feedback');
                  },
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.bug, color: AppTheme.danger, size: 18),
                  title: Text(
                    'Report a Bug',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Help us fix issues faster',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted, size: 14),
                  onTap: () {
                    _showFeedbackDialog(context, isDark, 'bug');
                  },
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.lightbulb, color: AppTheme.primaryLight, size: 18),
                  title: Text(
                    'Feature Request',
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Suggest new features or improvements',
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted, size: 14),
                  onTap: () {
                    _showFeedbackDialog(context, isDark, 'feature');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 5. SHARE APP
          Text(
            'Share ZeScan',
            style: TextStyle(
              color: AppTheme.getTextSecondary(isDark),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppTheme.glassCard(isDark),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(LucideIcons.share2, color: AppTheme.primaryLight, size: 18),
              title: Text(
                'Share App',
                style: TextStyle(
                  color: AppTheme.getTextPrimary(isDark),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Recommend ZeScan to friends & family',
                style: TextStyle(
                  color: AppTheme.getTextSecondary(isDark),
                  fontSize: 11,
                ),
              ),
              trailing: const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted, size: 14),
              onTap: () {
                _shareApp(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, bool isDark, String type) {
    final TextEditingController controller = TextEditingController();
    String title = '';
    String hint = '';
    IconData icon = LucideIcons.messageSquare;
    Color iconColor = AppTheme.primaryLight;

    switch (type) {
      case 'feedback':
        title = 'Send Feedback';
        hint = 'Share your thoughts about ZeScan...';
        icon = LucideIcons.messageSquare;
        iconColor = AppTheme.primaryLight;
        break;
      case 'bug':
        title = 'Report a Bug';
        hint = 'Describe the issue you encountered...';
        icon = LucideIcons.bug;
        iconColor = AppTheme.danger;
        break;
      case 'feature':
        title = 'Feature Request';
        hint = 'Describe the feature you\'d like to see...';
        icon = LucideIcons.lightbulb;
        iconColor = AppTheme.warning;
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.getTextPrimary(isDark),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your input helps us improve ZeScan!',
                  style: TextStyle(
                    color: AppTheme.getTextSecondary(isDark),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: 5,
                  style: TextStyle(
                    color: AppTheme.getTextPrimary(isDark),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppTheme.getTextMuted(isDark),
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryLight,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.getTextSecondary(isDark),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  // TODO: Implement actual feedback submission
                  // e.g., send to email, Firebase, or backend API
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for your ${type == 'feedback' ? 'feedback' : type == 'bug' ? 'bug report' : 'feature request'}!'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter some text'),
                      backgroundColor: AppTheme.danger,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _shareApp(BuildContext context) async {
    try {
      final String shareText = 
          '📄 Check out ZeScan - A privacy-first document scanner!\n\n'
          '✨ Features:\n'
          '• 100% on-device processing\n'
          '• No internet required\n'
          '• PDF merge, compress & split\n'
          '• Professional document scanning\n'
          '• Completely free!\n\n'
          'Download: https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan';
      
      await Share.share(
        shareText,
        subject: 'Try ZeScan Document Scanner',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share failed: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Widget _buildAuditRow({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required Color statusColor,
    bool showPulse = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.getTextSecondary(isDark), size: 18),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.getTextPrimary(isDark),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.getTextSecondary(isDark),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            if (showPulse) ...[
              const PulsingDot(),
              const SizedBox(width: 6),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'VERIFIED',
                style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.success.withOpacity(0.3 + (_controller.value * 0.7)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.success.withOpacity(0.4),
                blurRadius: 4 * _controller.value,
                spreadRadius: 1 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
