import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for managing PDF files and documents on disk
class FileManagerService {
  /// Get the directory where PDFs are stored
  static Future<Directory> getPdfDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${appDocDir.path}/ZeScan_PDFs');
    
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    
    return pdfDir;
  }

  /// Share a PDF file
  static Future<void> sharePdf(String? pdfPath, String documentName) async {
    try {
      if (pdfPath == null || pdfPath.isEmpty) {
        debugPrint('FileManagerService: No PDF path provided');
        throw Exception('PDF file not found');
      }

      final file = File(pdfPath);
      
      if (!await file.exists()) {
        debugPrint('FileManagerService: PDF file does not exist: $pdfPath');
        throw Exception('PDF file not found on disk');
      }

      debugPrint('FileManagerService: Sharing PDF: $pdfPath');
      
      await Share.shareXFiles(
        [XFile(pdfPath)],
        subject: documentName,
        text: 'Shared from ZeScan',
      );
    } catch (e) {
      debugPrint('FileManagerService: Error sharing PDF: $e');
      rethrow;
    }
  }

  /// Delete a PDF file from disk
  static Future<bool> deletePdf(String? pdfPath) async {
    try {
      if (pdfPath == null || pdfPath.isEmpty) {
        debugPrint('FileManagerService: No PDF path provided for deletion');
        return false;
      }

      final file = File(pdfPath);
      
      if (await file.exists()) {
        await file.delete();
        debugPrint('FileManagerService: Deleted PDF: $pdfPath');
        return true;
      } else {
        debugPrint('FileManagerService: PDF file does not exist: $pdfPath');
        return false;
      }
    } catch (e) {
      debugPrint('FileManagerService: Error deleting PDF: $e');
      return false;
    }
  }

  /// Check if a PDF file exists
  static Future<bool> pdfExists(String? pdfPath) async {
    if (pdfPath == null || pdfPath.isEmpty) return false;
    
    final file = File(pdfPath);
    return await file.exists();
  }

  /// Get the size of a PDF file in MB
  static Future<double> getPdfSize(String? pdfPath) async {
    try {
      if (pdfPath == null || pdfPath.isEmpty) return 0.0;
      
      final file = File(pdfPath);
      
      if (!await file.exists()) return 0.0;
      
      final bytes = await file.length();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (e) {
      debugPrint('FileManagerService: Error getting PDF size: $e');
      return 0.0;
    }
  }

  /// Rename a PDF file on disk
  static Future<String?> renamePdf(String? oldPath, String newName) async {
    try {
      if (oldPath == null || oldPath.isEmpty) {
        debugPrint('FileManagerService: No PDF path provided for rename');
        return null;
      }

      final oldFile = File(oldPath);
      
      if (!await oldFile.exists()) {
        debugPrint('FileManagerService: PDF file does not exist: $oldPath');
        return null;
      }

      // Sanitize new name
      final sanitizedName = newName.replaceAll(RegExp(r'[^\w\-.]'), '_');
      
      // Get directory and create new path
      final directory = oldFile.parent;
      final newPath = '${directory.path}/$sanitizedName.pdf';
      
      // Rename file
      final newFile = await oldFile.rename(newPath);
      debugPrint('FileManagerService: Renamed PDF from $oldPath to $newPath');
      
      return newFile.path;
    } catch (e) {
      debugPrint('FileManagerService: Error renaming PDF: $e');
      return null;
    }
  }

  /// List all PDF files in the ZeScan directory
  static Future<List<File>> listAllPdfs() async {
    try {
      final pdfDir = await getPdfDirectory();
      
      if (!await pdfDir.exists()) {
        return [];
      }

      final List<FileSystemEntity> entities = await pdfDir.list().toList();
      
      final pdfFiles = entities
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.pdf'))
          .toList();
      
      debugPrint('FileManagerService: Found ${pdfFiles.length} PDF files');
      
      return pdfFiles;
    } catch (e) {
      debugPrint('FileManagerService: Error listing PDFs: $e');
      return [];
    }
  }

  /// Get available storage space in MB
  static Future<double> getAvailableSpace() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final stat = await appDocDir.stat();
      // Note: This is a placeholder - actual implementation would need platform-specific code
      return 1000.0; // Return 1GB as placeholder
    } catch (e) {
      debugPrint('FileManagerService: Error getting available space: $e');
      return 0.0;
    }
  }

  /// Clean up temporary image files (after PDF generation)
  static Future<void> cleanupTempImages(List<String> imagePaths) async {
    try {
      for (final path in imagePaths) {
        // Only delete files in temp directory
        if (path.contains('/temp/') || path.contains('\\temp\\')) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
            debugPrint('FileManagerService: Deleted temp image: $path');
          }
        }
      }
    } catch (e) {
      debugPrint('FileManagerService: Error cleaning up temp images: $e');
    }
  }
}
