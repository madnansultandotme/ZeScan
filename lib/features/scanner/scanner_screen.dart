import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/permission_service.dart';
import 'preview_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  bool _isContinuousMode = false;
  bool _isScanning = false;

  // Camera state
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isCameraError = false;
  String _cameraErrorMessage = '';
  FlashMode _currentFlashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer camera init to after first frame so we have context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle for camera resource management
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    if (!mounted) return;
    final hasPermission = await PermissionService.requestCamera(context);

    if (!mounted) return;
    setState(() {
      _isCameraPermissionGranted = hasPermission;
    });

    if (!hasPermission) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isCameraError = true;
          _cameraErrorMessage = 'No cameras available on this device.';
        });
        return;
      }

      // Prefer back camera
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _isCameraError = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCameraError = true;
        _cameraErrorMessage = 'Camera initialization failed. You can still import from gallery.';
      });
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final newMode = _currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _cameraController!.setFlashMode(newMode);
      setState(() {
        _currentFlashMode = newMode;
      });
    } catch (e) {
      // Flash not supported on this device — ignore silently
    }
  }

  void _capturePage(BuildContext context) async {
    if (_isScanning || _cameraController == null || !_cameraController!.value.isInitialized) return;

    final state = AppStateProvider.of(context);

    // Free tier scanner limit check (10 pages in continuous mode)
    if (!state.isProUnlocked && state.scanQueue.length >= 10 && _isContinuousMode) {
      _showProModal(context);
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final XFile photo = await _cameraController!.takePicture();

      if (!mounted) return;

      state.addPageToScanQueue(photo.path);

      setState(() {
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Page ${state.scanQueue.length} captured!'),
          duration: const Duration(seconds: 1),
          backgroundColor: AppTheme.primaryLight,
        ),
      );

      if (!_isContinuousMode) {
        // Single Scan Mode: instantly push to Preview
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PreviewScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Capture failed: ${e.toString()}'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  void _pickFromGallery(BuildContext context) async {
    // Request photo permission first
    if (!mounted) return;
    final hasPermission = await PermissionService.requestPhotos(context);
    if (!hasPermission) return;

    final state = AppStateProvider.of(context);
    final picker = ImagePicker();

    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        for (var image in images) {
          state.addPageToScanQueue(image.path);
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PreviewScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gallery pick failed: ${e.toString()}'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  void _showProModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(LucideIcons.crown, color: AppTheme.warning),
            const SizedBox(width: 8),
            const Text('Unlock Pro Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Continuous scan mode is capped at 10 pages on the free tier. Unlock Pro for unlimited multi-page document scanning!',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final state = AppStateProvider.of(context);
              state.toggleProStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pro Tier Unlocked!'), backgroundColor: AppTheme.success),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Go Pro (\$2.99)', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final queueCount = state.scanQueue.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Viewport or Fallback
          Positioned.fill(
            child: _buildCameraView(),
          ),

          // 2. Camera Controls Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    if (_isCameraInitialized)
                      IconButton(
                        icon: Icon(
                          _currentFlashMode == FlashMode.off ? LucideIcons.zapOff : LucideIcons.zap,
                          color: _currentFlashMode == FlashMode.off ? Colors.white : AppTheme.warning,
                          size: 22,
                        ),
                        onPressed: _toggleFlash,
                      ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Scan Mode Toggle Footer Slider & Shutter Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mode Slider Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isContinuousMode = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: !_isContinuousMode ? AppTheme.primaryGlow : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Single Scan',
                            style: TextStyle(
                              color: !_isContinuousMode ? Colors.white : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          if (!state.isProUnlocked && queueCount >= 10) {
                            _showProModal(context);
                            return;
                          }
                          setState(() => _isContinuousMode = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isContinuousMode ? AppTheme.primaryGlow : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continuous',
                                style: TextStyle(
                                  color: _isContinuousMode ? Colors.white : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!state.isProUnlocked) ...[
                                const SizedBox(width: 4),
                                const Icon(LucideIcons.lock, color: AppTheme.warning, size: 10),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Capture Panel
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Gallery Button
                        IconButton(
                          icon: const Icon(LucideIcons.image, color: Colors.white, size: 28),
                          onPressed: () => _pickFromGallery(context),
                        ),
                        
                        // Shutter Button
                        GestureDetector(
                          onTap: _isCameraInitialized ? () => _capturePage(context) : null,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isCameraInitialized ? Colors.white : Colors.white38,
                                width: 4,
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isScanning
                                    ? AppTheme.success
                                    : (_isCameraInitialized ? Colors.white : Colors.white38),
                              ),
                            ),
                          ),
                        ),

                        // Queue Preview/Done Checkmark
                        GestureDetector(
                          onTap: () {
                            if (queueCount > 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const PreviewScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Capture at least 1 page first.')),
                              );
                            }
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: queueCount > 0 ? AppTheme.primary : AppTheme.surfaceDark,
                              border: Border.all(color: AppTheme.borderDark),
                            ),
                            child: Center(
                              child: queueCount > 0
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(LucideIcons.check, color: Colors.white, size: 20),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.white,
                                            child: Text(
                                              '$queueCount',
                                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Icon(LucideIcons.check, color: AppTheme.textMuted, size: 20),
                            ),
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
    );
  }

  /// Builds the camera preview area, or a fallback card if camera is unavailable.
  Widget _buildCameraView() {
    // Camera permission not granted
    if (!_isCameraPermissionGranted) {
      return _buildFallbackCard(
        icon: LucideIcons.cameraOff,
        title: 'Camera Permission Required',
        subtitle: 'Tap below to grant camera access, or import from gallery.',
        actionLabel: 'Grant Camera Access',
        onAction: () => _initializeCamera(),
      );
    }

    // Camera error (e.g., emulator with no camera)
    if (_isCameraError) {
      return _buildFallbackCard(
        icon: LucideIcons.alertTriangle,
        title: 'Camera Unavailable',
        subtitle: _cameraErrorMessage,
        actionLabel: 'Import from Gallery',
        onAction: () => _pickFromGallery(context),
      );
    }

    // Camera still initializing
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: const Color(0xFF0F0F13),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryLight),
              SizedBox(height: 16),
              Text(
                'Initializing Camera...',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Live camera preview
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _cameraController!.value.previewSize!.height,
            height: _cameraController!.value.previewSize!.width,
            child: CameraPreview(_cameraController!),
          ),
        ),
      ),
    );
  }

  /// Builds a styled fallback card for when the camera is not available.
  Widget _buildFallbackCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      color: const Color(0xFF0F0F13),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGlow,
                  border: Border.all(color: AppTheme.borderDark, width: 1),
                ),
                child: Icon(icon, color: AppTheme.primaryLight, size: 48),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(icon, size: 18),
                label: Text(actionLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
