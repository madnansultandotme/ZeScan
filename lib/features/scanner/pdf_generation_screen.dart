import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/pdf_service.dart';
import 'share_screen.dart';

/// Screen shown during PDF generation with ad placement for user retention
class PdfGenerationScreen extends StatefulWidget {
  final List<String> imagePaths;
  final String fileName;
  final String folderId;
  final PdfQuality quality;

  const PdfGenerationScreen({
    super.key,
    required this.imagePaths,
    required this.fileName,
    required this.folderId,
    required this.quality,
  });

  @override
  State<PdfGenerationScreen> createState() => _PdfGenerationScreenState();
}

class _PdfGenerationScreenState extends State<PdfGenerationScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.0);
  bool _isComplete = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Start PDF generation after a brief delay to ensure widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePDF();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  Future<void> _generatePDF() async {
    debugPrint('PdfGenerationScreen: _generatePDF started');
    
    final state = AppStateProvider.of(context);

    try {
      debugPrint('PdfGenerationScreen: Starting PDF generation with ${widget.imagePaths.length} images');
      
      // Verify all image paths exist
      int validImages = 0;
      for (var path in widget.imagePaths) {
        final file = File(path);
        final exists = await file.exists();
        debugPrint('PdfGenerationScreen: Image path: $path - exists: $exists');
        if (exists) {
          validImages++;
        }
      }
      debugPrint('PdfGenerationScreen: Valid images: $validImages / ${widget.imagePaths.length}');
      
      if (validImages == 0) {
        throw Exception('No valid image files found');
      }
      
      final result = await PdfService.generatePdf(
        imagePaths: widget.imagePaths,
        fileName: widget.fileName,
        quality: widget.quality,
        onProgress: (progress) {
          debugPrint('PdfGenerationScreen: Progress callback received: ${(progress * 100).toInt()}%');
          if (mounted) {
            _progressNotifier.value = progress;
            // Force a setState as well
            setState(() {});
          }
        },
      );

      debugPrint('PdfGenerationScreen: PDF generation completed. Path: ${result.filePath}');

      if (!mounted) return;

      // Mark as complete
      setState(() {
        _isComplete = true;
        _progressNotifier.value = 1.0;
      });

      // Wait a bit for the ad/animation
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // Finalize document
      final createdDoc = state.finalizeScanToDocument(
        name: widget.fileName,
        folderId: widget.folderId,
        sizeInMb: double.parse(result.fileSizeMb.toStringAsFixed(2)),
        pdfPath: result.filePath,
      );

      // Navigate to share screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShareScreen(document: createdDoc),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('PdfGenerationScreen: ERROR: $e');
      debugPrint('PdfGenerationScreen: Stack trace: $stackTrace');
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generation failed: ${e.toString()}'),
          backgroundColor: AppTheme.danger,
          duration: const Duration(seconds: 5),
        ),
      );
      
      // Go back on error
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Top section - PDF generation status
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated icon
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = 1.0 + (_pulseController.value * 0.1);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppTheme.primaryGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(0.3 + (_pulseController.value * 0.2)),
                                        blurRadius: 20 + (_pulseController.value * 10),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isComplete ? LucideIcons.checkCircle : LucideIcons.fileText,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Status text
                          Text(
                            _isComplete ? 'PDF Generated Successfully!' : 'Generating Your PDF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isComplete
                                ? 'Preparing to share...'
                                : 'Converting on-device... 100% Offline & Private',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          // Progress bar
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: ValueListenableBuilder<double>(
                              valueListenable: _progressNotifier,
                              builder: (context, progress, child) {
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 12,
                                        backgroundColor: AppTheme.borderDark,
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: AppTheme.primaryLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Page count info
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.borderDark),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.fileStack, color: AppTheme.primaryLight, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '${widget.imagePaths.length} page${widget.imagePaths.length > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
