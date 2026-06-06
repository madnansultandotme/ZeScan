import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme.dart';
import '../core/state/app_state_provider.dart';
import 'library/library_screen.dart';
import 'toolkit/toolkit_screen.dart';
import 'settings/settings_screen.dart';
import 'scanner/scanner_screen.dart';
import 'favorites/favorites_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LibraryScreen(),
    const ToolkitScreen(),
    const ScannerScreen(), // Quick Scan in center (index 2)
    const FavoritesScreen(), // Favorites screen
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
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
            // Start new scan when tapping Quick Scan (center button - index 2)
            if (index == 2) {
              state.startNewScan();
            }
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppTheme.getBackgroundColor(isDark),
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.getTextSecondary(isDark),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(LucideIcons.files, size: 22),
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(LucideIcons.briefcase, size: 22),
              ),
              label: 'Toolkit',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(LucideIcons.camera, size: 26),
              ),
              label: 'Quick Scan',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(LucideIcons.star, size: 22),
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(LucideIcons.settings, size: 22),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
