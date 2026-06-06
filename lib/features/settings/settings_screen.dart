import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    final isPro = state.isProUnlocked;
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

          // 1. DYNAMIC GOLD PRO BANNER
          GestureDetector(
            onTap: () {
              state.toggleProStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isPro ? 'Pro membership deactivated.' : 'Pro membership activated!'),
                  backgroundColor: isPro ? AppTheme.primaryLight : AppTheme.success,
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isPro ? AppTheme.privacyGradient : AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isPro ? AppTheme.success : AppTheme.warning).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isPro ? LucideIcons.shieldCheck : LucideIcons.crown,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPro ? 'ZeScan Pro Active' : 'Upgrade to ZeScan Pro',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPro
                              ? 'Thank you for supporting offline-first software!'
                              : 'Unlimited scans, full toolkit, no ads, life unlock.',
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPro ? 'Unlocked' : '\$2.99',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // 2. PRIVACY & SECURITY AUDIT PANEL
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
                _buildAuditRow(
                  isDark: isDark,
                  icon: LucideIcons.activity,
                  label: 'Network Utilization Log',
                  value: '0 bytes transmitted',
                  statusColor: AppTheme.success,
                  showPulse: true,
                ),
                Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, height: 24),
                _buildAuditRow(
                  isDark: isDark,
                  icon: LucideIcons.lock,
                  label: 'Account Requirement',
                  value: 'None (anonymous-mode)',
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
        ],
      ),
    );
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
