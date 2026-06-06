import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/pdf_service.dart';
import 'pdf_generation_screen.dart';

class ExportSheet extends StatefulWidget {
  const ExportSheet({super.key});

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedFolder = 'all';

  @override
  void initState() {
    super.initState();
    _nameController.text = 'ZeScan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';
  }

  /// Generates a real PDF from the scan queue images.
  /// First generates at medium quality, then checks if compression is needed.
  void _generatePDF({PdfQuality quality = PdfQuality.medium}) async {
    final state = AppStateProvider.of(context);
    // Filter out asset paths - only include real camera/gallery images
    final imagePaths = state.scanQueue
        .where((path) => !path.startsWith('assets/'))
        .toList();
    
    if (imagePaths.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid images to generate PDF. Please capture or import images.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
    
    final fileName = _nameController.text.trim();

    // Close the export sheet
    Navigator.pop(context);

    // Navigate to PDF generation screen with ad
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfGenerationScreen(
          imagePaths: imagePaths,
          fileName: fileName,
          folderId: _selectedFolder,
          quality: quality,
        ),
      ),
    );
  }

  /// Shows dialog when PDF size exceeds 25MB
  void _showCompressionDialog(double currentSizeMB, String fileName) {
    // This is now handled in PdfGenerationScreen, but keeping for reference
    // We'll implement size check logic in the generation screen
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
      child: _buildSettingsForm(state),
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
            onPressed: _generatePDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.fileText, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Generate PDF',
                  style: TextStyle(
                    color: Colors.white,
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
}
