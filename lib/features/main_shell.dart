import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme.dart';
import '../core/state/app_state_provider.dart';
import 'library/library_screen.dart';
import 'toolkit/toolkit_screen.dart';
import 'settings/settings_screen.dart';
import 'scanner/scanner_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabController;

  final List<Widget> _screens = [
    const LibraryScreen(),
    const ToolkitScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // FAB pulsing animation
    _fabController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isLibraryEmpty = state.documents.isEmpty;
    final isDark = state.isDarkMode;

    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(isDark),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: isDark ? AppTheme.borderDark : AppTheme.borderLight, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppTheme.getBackgroundColor(isDark),
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.getTextSecondary(isDark),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.files),
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.briefcase),
              ),
              label: 'Toolkit',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.settings),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          // Pulse effect only when library is empty to guide the user
          final scale = isLibraryEmpty ? 1.0 + (_fabController.value * 0.08) : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(isLibraryEmpty ? 0.4 + (_fabController.value * 0.2) : 0.4),
                    blurRadius: isLibraryEmpty ? 12 + (_fabController.value * 6) : 12,
                    spreadRadius: isLibraryEmpty ? 1 + (_fabController.value * 2) : 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  state.startNewScan();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScannerScreen()),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.primaryLight, width: 1),
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.camera, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      isLibraryEmpty ? 'Scan First Doc' : 'Quick Scan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                icon: null,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
