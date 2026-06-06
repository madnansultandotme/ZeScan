import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// Quality presets for PDF image compression.
enum PdfQuality {
  low,    // ~50% JPEG quality — smaller files for quick sharing
  medium, // ~75% JPEG quality — balanced default
  high,   // ~100% quality — best for printing
}

/// Result of a PDF generation operation.
class PdfResult {
  final String filePath;
  final int fileSizeBytes;
  final int pageCount;

  PdfResult({
    required this.filePath,
    required this.fileSizeBytes,
    required this.pageCount,
  });

  double get fileSizeMb => fileSizeBytes / (1024 * 1024);
}

/// Pure Dart PDF generation service. Reads image files from disk, composes
/// them into a multi-page A4 PDF, and saves to the app's documents directory.
/// All processing is 100% on-device with zero network calls.
class PdfService {
  /// Generate a PDF from a list of image file paths.
  ///
  /// [imagePaths] — Absolute paths to image files (JPEG, PNG)
  /// [fileName] — The desired output file name (without extension)
  /// [quality] — Compression quality preset
  /// [onProgress] — Optional callback for progress updates (0.0 to 1.0)
  ///
  /// Returns a [PdfResult] with the file path and metadata.
  static Future<PdfResult> generatePdf({
    required List<String> imagePaths,
    required String fileName,
    PdfQuality quality = PdfQuality.medium,
    void Function(double progress)? onProgress,
  }) async {
    final pdf = pw.Document();
    final totalPages = imagePaths.length;

    for (int i = 0; i < totalPages; i++) {
      final imagePath = imagePaths[i];
      final file = File(imagePath);

      if (!await file.exists()) {
        debugPrint('PdfService: Skipping non-existent file: $imagePath');
        continue;
      }

      try {
        final Uint8List imageBytes = await file.readAsBytes();
        final pw.MemoryImage image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                  dpi: _getDpi(quality),
                ),
              );
            },
          ),
        );
      } catch (e) {
        debugPrint('PdfService: Error processing image $imagePath: $e');
        continue;
      }

      // Report progress
      onProgress?.call((i + 1) / totalPages);
    }

    // Save to app documents directory
    final outputDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${outputDir.path}/ZeScan_PDFs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    final sanitizedName = fileName.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final outputPath = '${pdfDir.path}/$sanitizedName.pdf';
    final outputFile = File(outputPath);
    
    final Uint8List pdfBytes = await pdf.save();
    await outputFile.writeAsBytes(pdfBytes);

    return PdfResult(
      filePath: outputPath,
      fileSizeBytes: pdfBytes.length,
      pageCount: totalPages,
    );
  }

  /// Estimate output file sizes for all quality presets in a single pass.
  /// Reads file sizes once and computes all 3 estimates.
  /// Returns a map: {PdfQuality.low: sizeMB, PdfQuality.medium: sizeMB, PdfQuality.high: sizeMB}
  static Future<Map<PdfQuality, double>> estimateAllSizes({
    required List<String> imagePaths,
  }) async {
    double totalImageBytes = 0;
    int validFileCount = 0;

    for (final path in imagePaths) {
      // Skip asset paths — they aren't real files on disk
      if (path.startsWith('assets/')) continue;
      final file = File(path);
      if (await file.exists()) {
        totalImageBytes += await file.length();
        validFileCount++;
      }
    }

    // If no valid files, return minimal estimates
    if (validFileCount == 0) {
      return {
        PdfQuality.low: 0.1,
        PdfQuality.medium: 0.2,
        PdfQuality.high: 0.3,
      };
    }

    final double pdfOverheadBytes = validFileCount * 10 * 1024; // ~10KB per page

    return {
      for (final q in PdfQuality.values)
        q: ((totalImageBytes * _getCompressionRatio(q)) + pdfOverheadBytes) / (1024 * 1024),
    };
  }

  static double _getDpi(PdfQuality quality) {
    switch (quality) {
      case PdfQuality.low:
        return 72;
      case PdfQuality.medium:
        return 150;
      case PdfQuality.high:
        return 300;
    }
  }

  static double _getCompressionRatio(PdfQuality quality) {
    switch (quality) {
      case PdfQuality.low:
        return 0.3;  // ~30% of original size
      case PdfQuality.medium:
        return 0.6;  // ~60% of original size
      case PdfQuality.high:
        return 0.9;  // ~90% of original size
    }
  }
}
