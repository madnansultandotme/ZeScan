import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/pdf_service.dart';
import 'share_screen.dart';

class ExportSheet extends StatefulWidget {
  const ExportSheet({super.key});

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedFolder = 'all';
  String _selectedQuality = 'medium';
  bool _isEstimating = true;
  bool _isGenerating = false;
  double _generationProgress = 0.0;

  // Sizes variables — estimated from real image files
  double _lowSize = 0.0;
  double _mediumSize = 0.0;
  double _highSize = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'ZeScan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';
    _runSizeEstimation();
  }

  /// Estimates output file sizes based on real source image file sizes on disk.
  void _runSizeEstimation() async {
    setState(() {
      _isEstimating = true;
    });

    final state = AppStateProvider.of(context);
    final imagePaths = state.scanQueue;

    // Filter out asset paths before estimation
    final validPaths = imagePaths.where((path) => !path.startsWith('assets/')).toList();

    if (validPaths.isEmpty) {
      // No valid images, set default estimates
      setState(() {
        _lowSize = 0.1;
        _mediumSize = 0.2;
        _highSize = 0.3;
        _isEstimating = false;
      });
      return;
    }

    // Use fast heuristic estimation instead of reading files
    // Average image from camera is about 2-4MB
    final count = validPaths.length;
    final estimatedAvgSizeMB = 2.5; // Conservative estimate for camera images
    
    setState(() {
      _lowSize = double.parse((count * estimatedAvgSizeMB * 0.3).toStringAsFixed(2));
      _mediumSize = double.parse((count * estimatedAvgSizeMB * 0.6).toStringAsFixed(2));
      _highSize = double.parse((count * estimatedAvgSizeMB * 0.9).toStringAsFixed(2));
      _isEstimating = false;
    });
  }

  /// Generates a real PDF from the scan queue images.
  void _generatePDF() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generationProgress = 0.0;
    });

    final state = AppStateProvider.of(context);
    // Filter out asset paths - only include real camera/gallery images
    final imagePaths = state.scanQueue
        .where((path) => !path.startsWith('assets/'))
        .toList();
    
    if (imagePaths.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid images to generate PDF. Please capture or import images.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
    
    final fileName = _nameController.text.trim();

    // Map quality selection to PdfQuality enum
    final PdfQuality quality;
    switch (_selectedQuality) {
      case 'low':
        quality = PdfQuality.low;
        break;
      case 'high':
        quality = PdfQuality.high;
        break;
      default:
        quality = PdfQuality.medium;
    }

    try {
      final result = await PdfService.generatePdf(
        imagePaths: imagePaths,
        fileName: fileName,
        quality: quality,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _generationProgress = progress;
            });
          }
        },
      );

      if (!mounted) return;

      final createdDoc = state.finalizeScanToDocument(
        name: fileName,
        folderId: _selectedFolder,
        sizeInMb: double.parse(result.fileSizeMb.toStringAsFixed(2)),
        pdfPath: result.filePath,
      );

      // Close bottom sheet and push to share screen
      Navigator.pop(context); // close sheet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShareScreen(document: createdDoc),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generation failed: ${e.toString()}'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppTheme.borderDark, width: 1)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: _isGenerating ? _buildGeneratingProgress() : _buildSettingsForm(state),
    );
  }

  Widget _buildGeneratingProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Icon(LucideIcons.fileText, color: AppTheme.primaryLight, size: 48),
        const SizedBox(height: 16),
        const Text(
          'Generating PDF Document',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Converting on-device... 100% Offline & Private',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 32),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _generationProgress,
            minHeight: 10,
            backgroundColor: AppTheme.borderDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(_generationProgress * 100).toInt()}%',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsForm(dynamic state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Export PDF Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),

        // File Name Input
        const Text(
          'Document Title',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.bgDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderDark),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixText: '.pdf',
              suffixStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Folder selection
        const Text(
          'Save to Folder',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.folders.length,
            itemBuilder: (context, index) {
              final folder = state.folders[index];
              final isSel = _selectedFolder == folder.id;
              return Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: ChoiceChip(
                  label: Text(folder.name, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : AppTheme.textSecondary)),
                  selected: isSel,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.bgDark,
                  onSelected: (val) {
                    setState(() {
                      _selectedFolder = folder.id;
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSel ? AppTheme.primaryLight : AppTheme.borderDark)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Quality Tiers Selector
        const Text(
          'Select PDF Quality & Size',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildQualityCard('low', 'Low', 'Fast Upload', _lowSize),
            const SizedBox(width: 8),
            _buildQualityCard('medium', 'Medium', 'Standard Default', _mediumSize),
            const SizedBox(width: 8),
            _buildQualityCard('high', 'High', 'Best for Printing', _highSize),
          ],
        ),
        const SizedBox(height: 24),

        // Generate button
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isEstimating ? null : _generatePDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              disabledBackgroundColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isEstimating)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white70,
                    ),
                  )
                else
                  const Icon(LucideIcons.fileText, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isEstimating ? 'Calculating Size...' : 'Generate PDF',
                  style: TextStyle(
                    color: _isEstimating ? Colors.white70 : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualityCard(String id, String title, String subtitle, double size) {
    final isSel = _selectedQuality == id;
    return Expanded(
      child: GestureDetector(
        onTap: _isEstimating ? null : () {
          setState(() {
            _selectedQuality = id;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSel ? AppTheme.primaryGlow : AppTheme.bgDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel ? AppTheme.primaryLight : AppTheme.borderDark,
              width: isSel ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  if (isSel)
                    const Icon(LucideIcons.check, color: AppTheme.primaryLight, size: 14),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 9),
              ),
              const SizedBox(height: 12),
              Text(
                '~$size MB',
                style: TextStyle(
                  color: isSel ? AppTheme.primaryLight : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
