import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pdfx/pdfx.dart';
import '../../core/theme.dart';
import '../../core/services/file_manager_service.dart';

/// Built-in PDF viewer screen for viewing PDFs within the app
class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String documentName;

  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.documentName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfController _pdfController;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showToolbar = true;

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  Future<void> _initializePdfController() async {
    try {
      _pdfController = PdfController(
        document: PdfDocument.openFile(widget.pdfPath),
      );

      // Wait for document to load to get page count
      final document = await PdfDocument.openFile(widget.pdfPath);
      
      setState(() {
        _totalPages = document.pagesCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  void _shareDocument() async {
    try {
      await FileManagerService.sharePdf(widget.pdfPath, widget.documentName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  void _zoomIn() {
    // Note: pdfx package doesn't support programmatic zoom control
    // Zoom is handled via pinch gestures in PdfView
  }

  void _zoomOut() {
    // Note: pdfx package doesn't support programmatic zoom control
    // Zoom is handled via pinch gestures in PdfView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _showToolbar
          ? AppBar(
              backgroundColor: Colors.black,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_totalPages > 0)
                    Text(
                      'Page $_currentPage of $_totalPages',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                ],
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.share2, color: Colors.white),
                  tooltip: 'Share',
                  onPressed: _shareDocument,
                ),
              ],
            )
          : null,
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primaryLight),
                  SizedBox(height: 16),
                  Text(
                    'Loading PDF...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.alertCircle, color: AppTheme.danger, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load PDF',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    // PDF Viewer
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showToolbar = !_showToolbar;
                        });
                      },
                      child: PdfView(
                        controller: _pdfController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        onDocumentLoaded: (document) {
                          setState(() {
                            _totalPages = document.pagesCount;
                          });
                        },
                      ),
                    ),

                    // Floating navigation controls
                    if (_showToolbar && _totalPages > 1)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                                  onPressed: _currentPage > 1
                                      ? () {
                                          _pdfController.previousPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$_currentPage / $_totalPages',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronRight, color: Colors.white),
                                  onPressed: _currentPage < _totalPages
                                      ? () {
                                          _pdfController.nextPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
