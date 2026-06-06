import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../core/theme.dart';

/// Screen for manual image editing - crop and rotate
class ImageEditorScreen extends StatefulWidget {
  final String imagePath;
  final List<img.Point>? detectedCorners; // ML Kit detected corners
  final Function(String editedPath) onSave; // Simplified callback - no enhancement toggle

  const ImageEditorScreen({
    super.key,
    required this.imagePath,
    this.detectedCorners,
    required this.onSave,
  });

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

enum _DragHandle {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topEdge,
  bottomEdge,
  leftEdge,
  rightEdge,
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  int _rotation = 0; // 0, 90, 180, 270
  bool _isProcessing = false;
  img.Image? _originalImage;
  img.Image? _displayImage;
  
  // Crop rectangle (normalized 0-1) - will be set from detected corners or default
  late Rect _cropRect;
  bool _isCropping = true; // Start in crop mode
  _DragHandle _currentDragHandle = _DragHandle.none;

  @override
  void initState() {
    super.initState();
    _initializeCropRect();
    _loadImage();
  }

  /// Initialize crop rect from detected corners or use default
  void _initializeCropRect() {
    if (widget.detectedCorners != null && widget.detectedCorners!.length == 4) {
      debugPrint('ImageEditorScreen: Using detected corners for initial crop');
      // Convert corners to normalized rect
      _cropRect = _cornersToRect(widget.detectedCorners!);
    } else {
      debugPrint('ImageEditorScreen: No corners detected, using default crop area');
      // Default crop area (slightly inset from edges)
      _cropRect = const Rect.fromLTWH(0.05, 0.1, 0.9, 0.8);
    }
  }

  /// Convert detected corners (in pixels) to normalized rect
  Rect _cornersToRect(List<img.Point> corners) {
    // Corners order: [topLeft, topRight, bottomRight, bottomLeft]
    final topLeft = corners[0];
    final topRight = corners[1];
    final bottomRight = corners[2];
    final bottomLeft = corners[3];

    // Find bounding box
    final minX = [topLeft.x, topRight.x, bottomRight.x, bottomLeft.x]
        .map((v) => v.toInt())
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxX = [topLeft.x, topRight.x, bottomRight.x, bottomLeft.x]
        .map((v) => v.toInt())
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final minY = [topLeft.y, topRight.y, bottomRight.y, bottomLeft.y]
        .map((v) => v.toInt())
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxY = [topLeft.y, topRight.y, bottomRight.y, bottomLeft.y]
        .map((v) => v.toInt())
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    // Normalize to 0-1 range (will be set properly once image is loaded)
    // For now, use reasonable defaults
    return Rect.fromLTWH(
      (minX / 1000).clamp(0.0, 0.9),
      (minY / 1500).clamp(0.0, 0.9),
      ((maxX - minX) / 1000).clamp(0.1, 1.0),
      ((maxY - minY) / 1500).clamp(0.1, 1.0),
    );
  }

  Future<void> _loadImage() async {
    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image != null) {
        setState(() {
          _originalImage = image;
          _displayImage = image.clone();

          // Update crop rect with actual image dimensions if corners were detected
          if (widget.detectedCorners != null && widget.detectedCorners!.length == 4) {
            _cropRect = _cornersToNormalizedRect(widget.detectedCorners!, image.width, image.height);
            debugPrint('ImageEditorScreen: Crop rect set to: $_cropRect');
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load image: $e');
    }
  }

  /// Convert detected corners to normalized rect using actual image dimensions
  Rect _cornersToNormalizedRect(List<img.Point> corners, int imageWidth, int imageHeight) {
    // Corners order: [topLeft, topRight, bottomRight, bottomLeft]
    final topLeft = corners[0];
    final topRight = corners[1];
    final bottomRight = corners[2];
    final bottomLeft = corners[3];

    // Find bounding box in pixels
    final minX = [topLeft.x, topRight.x, bottomRight.x, bottomLeft.x]
        .map((v) => v.toInt())
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxX = [topLeft.x, topRight.x, bottomRight.x, bottomLeft.x]
        .map((v) => v.toInt())
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final minY = [topLeft.y, topRight.y, bottomRight.y, bottomLeft.y]
        .map((v) => v.toInt())
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxY = [topLeft.y, topRight.y, bottomRight.y, bottomLeft.y]
        .map((v) => v.toInt())
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    // Normalize to 0-1 range based on actual image dimensions
    final normalizedLeft = (minX / imageWidth).clamp(0.0, 0.95);
    final normalizedTop = (minY / imageHeight).clamp(0.0, 0.95);
    final normalizedWidth = ((maxX - minX) / imageWidth).clamp(0.05, 1.0 - normalizedLeft);
    final normalizedHeight = ((maxY - minY) / imageHeight).clamp(0.05, 1.0 - normalizedTop);

    debugPrint('ImageEditorScreen: Detected corners normalized - L:$normalizedLeft T:$normalizedTop W:$normalizedWidth H:$normalizedHeight');

    return Rect.fromLTWH(
      normalizedLeft,
      normalizedTop,
      normalizedWidth,
      normalizedHeight,
    );
  }

  void _rotateImage() {
    if (_originalImage == null) return;

    setState(() {
      _rotation = (_rotation + 90) % 360;
      _displayImage = _applyRotation(_originalImage!.clone(), _rotation);
    });
  }

  img.Image _applyRotation(img.Image image, int degrees) {
    switch (degrees) {
      case 90:
        return img.copyRotate(image, angle: 90);
      case 180:
        return img.copyRotate(image, angle: 180);
      case 270:
        return img.copyRotate(image, angle: 270);
      default:
        return image;
    }
  }

  void _resetCrop() {
    setState(() {
      _cropRect = const Rect.fromLTWH(0.0, 0.0, 1.0, 1.0);
    });
  }

  Future<void> _saveImage() async {
    if (_originalImage == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      img.Image processed = _originalImage!.clone();

      // Apply rotation first
      if (_rotation != 0) {
        processed = _applyRotation(processed, _rotation);
      }

      // Apply crop
      if (_cropRect.left != 0.0 || _cropRect.top != 0.0 || 
          _cropRect.width != 1.0 || _cropRect.height != 1.0) {
        final x = (processed.width * _cropRect.left).toInt();
        final y = (processed.height * _cropRect.top).toInt();
        final width = (processed.width * _cropRect.width).toInt();
        final height = (processed.height * _cropRect.height).toInt();

        processed = img.copyCrop(
          processed,
          x: x,
          y: y,
          width: width.clamp(1, processed.width - x),
          height: height.clamp(1, processed.height - y),
        );
      }

      // Save to temp directory (no enhancement applied)
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(processed, quality: 95));

      debugPrint('ImageEditorScreen: Image saved without enhancement: $outputPath');

      if (mounted) {
        widget.onSave(outputPath);
      }
    } catch (e) {
      debugPrint('ImageEditorScreen: Failed to save image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDetectedCorners = widget.detectedCorners != null && widget.detectedCorners!.length == 4;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text('Crop', style: TextStyle(color: Colors.white)),
            if (hasDetectedCorners) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00CED1).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF00CED1), width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.scan, color: Color(0xFF00CED1), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Auto-detected',
                      style: TextStyle(
                        color: Color(0xFF00CED1),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!_isProcessing)
            IconButton(
              icon: const Icon(LucideIcons.check, color: Colors.white),
              onPressed: _saveImage,
              tooltip: 'Save',
            ),
        ],
      ),
      body: Column(
        children: [
          // Image display area
          Expanded(
            child: _displayImage == null
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryLight),
                  )
                : Stack(
                    children: [
                      // Display image
                      Center(
                        child: _buildImageWithCropOverlay(),
                      ),
                      
                      // Processing overlay
                      if (_isProcessing)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: AppTheme.primaryLight),
                                SizedBox(height: 16),
                                Text(
                                  'Processing...',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),

          // Bottom controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomAction(
                  icon: LucideIcons.rotateCcw,
                  label: 'Left',
                  onPressed: () {
                    setState(() {
                      _rotation = (_rotation - 90) % 360;
                      if (_rotation < 0) _rotation += 360;
                      _displayImage = _applyRotation(_originalImage!.clone(), _rotation);
                    });
                  },
                ),
                _buildBottomAction(
                  icon: LucideIcons.rotateCw,
                  label: 'Right',
                  onPressed: _rotateImage,
                ),
                _buildBottomAction(
                  icon: LucideIcons.maximize2,
                  label: 'All',
                  onPressed: _resetCrop,
                ),
                _buildBottomAction(
                  icon: LucideIcons.arrowRight,
                  label: 'Next',
                  onPressed: _saveImage,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithCropOverlay() {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 4.0,
      child: Stack(
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
          ),
          if (_isCropping)
            Positioned.fill(
              child: _buildCropOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildCropOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return GestureDetector(
          onPanStart: (details) {
            final localPos = details.localPosition;
            setState(() {
              _currentDragHandle = _getHandleAtPosition(localPos, width, height);
            });
          },
          onPanUpdate: (details) {
            if (_currentDragHandle == _DragHandle.none) return;

            setState(() {
              final dx = details.delta.dx / width;
              final dy = details.delta.dy / height;

              switch (_currentDragHandle) {
                case _DragHandle.topLeft:
                  _cropRect = Rect.fromLTRB(
                    (_cropRect.left + dx).clamp(0.0, _cropRect.right - 0.1),
                    (_cropRect.top + dy).clamp(0.0, _cropRect.bottom - 0.1),
                    _cropRect.right,
                    _cropRect.bottom,
                  );
                  break;
                case _DragHandle.topRight:
                  _cropRect = Rect.fromLTRB(
                    _cropRect.left,
                    (_cropRect.top + dy).clamp(0.0, _cropRect.bottom - 0.1),
                    (_cropRect.right + dx).clamp(_cropRect.left + 0.1, 1.0),
                    _cropRect.bottom,
                  );
                  break;
                case _DragHandle.bottomLeft:
                  _cropRect = Rect.fromLTRB(
                    (_cropRect.left + dx).clamp(0.0, _cropRect.right - 0.1),
                    _cropRect.top,
                    _cropRect.right,
                    (_cropRect.bottom + dy).clamp(_cropRect.top + 0.1, 1.0),
                  );
                  break;
                case _DragHandle.bottomRight:
                  _cropRect = Rect.fromLTRB(
                    _cropRect.left,
                    _cropRect.top,
                    (_cropRect.right + dx).clamp(_cropRect.left + 0.1, 1.0),
                    (_cropRect.bottom + dy).clamp(_cropRect.top + 0.1, 1.0),
                  );
                  break;
                case _DragHandle.topEdge:
                  _cropRect = Rect.fromLTRB(
                    _cropRect.left,
                    (_cropRect.top + dy).clamp(0.0, _cropRect.bottom - 0.1),
                    _cropRect.right,
                    _cropRect.bottom,
                  );
                  break;
                case _DragHandle.bottomEdge:
                  _cropRect = Rect.fromLTRB(
                    _cropRect.left,
                    _cropRect.top,
                    _cropRect.right,
                    (_cropRect.bottom + dy).clamp(_cropRect.top + 0.1, 1.0),
                  );
                  break;
                case _DragHandle.leftEdge:
                  _cropRect = Rect.fromLTRB(
                    (_cropRect.left + dx).clamp(0.0, _cropRect.right - 0.1),
                    _cropRect.top,
                    _cropRect.right,
                    _cropRect.bottom,
                  );
                  break;
                case _DragHandle.rightEdge:
                  _cropRect = Rect.fromLTRB(
                    _cropRect.left,
                    _cropRect.top,
                    (_cropRect.right + dx).clamp(_cropRect.left + 0.1, 1.0),
                    _cropRect.bottom,
                  );
                  break;
                case _DragHandle.none:
                  break;
              }
            });
          },
          onPanEnd: (_) {
            setState(() {
              _currentDragHandle = _DragHandle.none;
            });
          },
          child: CustomPaint(
            painter: _CropOverlayPainter(_cropRect),
          ),
        );
      },
    );
  }

  _DragHandle _getHandleAtPosition(Offset pos, double width, double height) {
    const hitSize = 40.0; // Hit area for handles
    
    final cropLeft = _cropRect.left * width;
    final cropTop = _cropRect.top * height;
    final cropRight = _cropRect.right * width;
    final cropBottom = _cropRect.bottom * height;
    final cropCenterX = (cropLeft + cropRight) / 2;
    final cropCenterY = (cropTop + cropBottom) / 2;

    // Check corner handles first
    if ((pos.dx - cropLeft).abs() < hitSize && (pos.dy - cropTop).abs() < hitSize) {
      return _DragHandle.topLeft;
    }
    if ((pos.dx - cropRight).abs() < hitSize && (pos.dy - cropTop).abs() < hitSize) {
      return _DragHandle.topRight;
    }
    if ((pos.dx - cropLeft).abs() < hitSize && (pos.dy - cropBottom).abs() < hitSize) {
      return _DragHandle.bottomLeft;
    }
    if ((pos.dx - cropRight).abs() < hitSize && (pos.dy - cropBottom).abs() < hitSize) {
      return _DragHandle.bottomRight;
    }

    // Check edge handles
    if ((pos.dy - cropTop).abs() < hitSize && (pos.dx - cropCenterX).abs() < hitSize) {
      return _DragHandle.topEdge;
    }
    if ((pos.dy - cropBottom).abs() < hitSize && (pos.dx - cropCenterX).abs() < hitSize) {
      return _DragHandle.bottomEdge;
    }
    if ((pos.dx - cropLeft).abs() < hitSize && (pos.dy - cropCenterY).abs() < hitSize) {
      return _DragHandle.leftEdge;
    }
    if ((pos.dx - cropRight).abs() < hitSize && (pos.dy - cropCenterY).abs() < hitSize) {
      return _DragHandle.rightEdge;
    }

    return _DragHandle.none;
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: _isProcessing ? null : onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPrimary ? const Color(0xFF00A86B) : Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for crop overlay with corner and edge handles
class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  _CropOverlayPainter(this.cropRect);

  @override
  void paint(Canvas canvas, Size size) {
    // Semi-transparent overlay outside crop area
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final cropRectPixels = Rect.fromLTWH(
      cropRect.left * size.width,
      cropRect.top * size.height,
      cropRect.width * size.width,
      cropRect.height * size.height,
    );

    // Draw overlay with hole for crop area
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(cropRectPixels)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    // Draw crop border (teal color like screenshot)
    final borderPaint = Paint()
      ..color = const Color(0xFF00CED1) // Teal/cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRect(cropRectPixels, borderPaint);

    // Draw corner handles (larger circles)
    final cornerHandlePaint = Paint()
      ..color = const Color(0xFF00CED1)
      ..style = PaintingStyle.fill;

    const cornerSize = 16.0;
    final corners = [
      Offset(cropRectPixels.left, cropRectPixels.top), // TL
      Offset(cropRectPixels.right, cropRectPixels.top), // TR
      Offset(cropRectPixels.left, cropRectPixels.bottom), // BL
      Offset(cropRectPixels.right, cropRectPixels.bottom), // BR
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, cornerSize / 2, cornerHandlePaint);
    }

    // Draw edge handles (rounded rectangles on midpoints)
    final edgeHandlePaint = Paint()
      ..color = const Color(0xFF00CED1)
      ..style = PaintingStyle.fill;

    const edgeWidth = 40.0;
    const edgeHeight = 12.0;

    // Top edge handle
    final topEdge = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset((cropRectPixels.left + cropRectPixels.right) / 2, cropRectPixels.top),
        width: edgeWidth,
        height: edgeHeight,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(topEdge, edgeHandlePaint);

    // Bottom edge handle
    final bottomEdge = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset((cropRectPixels.left + cropRectPixels.right) / 2, cropRectPixels.bottom),
        width: edgeWidth,
        height: edgeHeight,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(bottomEdge, edgeHandlePaint);

    // Left edge handle
    final leftEdge = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRectPixels.left, (cropRectPixels.top + cropRectPixels.bottom) / 2),
        width: edgeHeight,
        height: edgeWidth,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(leftEdge, edgeHandlePaint);

    // Right edge handle
    final rightEdge = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cropRectPixels.right, (cropRectPixels.top + cropRectPixels.bottom) / 2),
        width: edgeHeight,
        height: edgeWidth,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(rightEdge, edgeHandlePaint);
  }

  @override
  bool shouldRepaint(_CropOverlayPainter oldDelegate) =>
      oldDelegate.cropRect != cropRect;
}
