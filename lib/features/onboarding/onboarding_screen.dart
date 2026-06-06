import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      illustration: 'assets/illustrations/Privacy policy-pana.svg',
      title: 'Privacy First',
      subtitle: 'Your documents stay secure and private',
      description: 'Scan and manage documents with confidence. Your files, your control.',
    ),
    OnboardingPage(
      illustration: 'assets/illustrations/undraw_file-bundle_oaof.svg',
      title: 'Powerful PDF Tools',
      subtitle: 'Merge, compress, and split PDFs easily',
      description: 'Professional PDF utilities built right into your scanner. No extra apps needed.',
    ),
    OnboardingPage(
      illustration: 'assets/illustrations/undraw_my-files_1xwx.svg',
      title: 'Organize Your Documents',
      subtitle: 'Keep all your scans in one place',
      description: 'Easy-to-use library with search and quick access to all your documents.',
    ),
    OnboardingPage(
      illustration: 'assets/illustrations/File searching-pana.svg',
      title: 'No Watermarks',
      subtitle: 'Clean, professional documents every time',
      description: 'Get beautiful scans without annoying watermarks or limitations.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    final state = AppStateProvider.of(context);
    state.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final isDark = state.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: AppTheme.getTextPrimary(isDark),
                        ),
                      ),
                    ],
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppTheme.getTextSecondary(isDark),
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page view with illustrations
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], isDark);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index == _currentPage, isDark),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          SvgPicture.asset(
            page.illustration,
            height: 280,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => Container(
              height: 280,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: AppTheme.primaryLight),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(isDark),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getTextSecondary(isDark),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryLight
            : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String illustration;
  final String title;
  final String subtitle;
  final String description;

  const OnboardingPage({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}
