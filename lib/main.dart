import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'core/theme.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_provider.dart';
import 'features/main_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppStateProvider(
      notifier: AppState(),
      child: const ZeScanApp(),
    ),
  );
}

class ZeScanApp extends StatefulWidget {
  const ZeScanApp({super.key});

  @override
  State<ZeScanApp> createState() => _ZeScanAppState();
}

class _ZeScanAppState extends State<ZeScanApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Brief splash delay to showcase brand loading screen
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    final state = AppStateProvider.of(context);
    await state.initPreferences();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    
    if (_isLoading) {
      return MaterialApp(
        title: 'ZeScan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          backgroundColor: AppTheme.bgDark,
          body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryLight),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'ZeScan',
      debugShowCheckedModeBanner: false,
      theme: state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: state.isOnboardingCompleted ? const MainShell() : const OnboardingScreen(),
    );
  }
}

