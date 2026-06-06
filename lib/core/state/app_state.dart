import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document.dart';
import '../services/file_manager_service.dart';
import '../services/pdf_service.dart';

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();

  // Preferences State
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  bool _isOnboardingCompleted = false;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Settings & Pro State
  bool _isProUnlocked = false;
  bool get isProUnlocked => _isProUnlocked;
  
  // Simulated scan limit tracking
  int _dailyScanCount = 2;
  int get dailyScanCount => _dailyScanCount;
  int get freeScanLimit => 5;

  Future<void> initPreferences() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('is_dark_mode') ?? true;
      _isOnboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      
      // Load saved documents
      await _loadDocuments();
    } catch (e) {
      debugPrint('AppState: Failed to init preferences: $e');
      _isDarkMode = true;
      _isOnboardingCompleted = false;
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Load documents from shared preferences
  Future<void> _loadDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = prefs.getString('documents');
      
      if (documentsJson != null) {
        final List<dynamic> decoded = jsonDecode(documentsJson);
        _documents.clear();
        _documents.addAll(
          decoded.map((json) => Document.fromJson(json as Map<String, dynamic>)).toList(),
        );
        debugPrint('AppState: Loaded ${_documents.length} documents from storage');
      } else {
        debugPrint('AppState: No saved documents found');
      }
    } catch (e) {
      debugPrint('AppState: Failed to load documents: $e');
    }
  }

  /// Save documents to shared preferences
  Future<void> _saveDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_documents.map((doc) => doc.toJson()).toList());
      await prefs.setString('documents', encoded);
      debugPrint('AppState: Saved ${_documents.length} documents to storage');
    } catch (e) {
      debugPrint('AppState: Failed to save documents: $e');
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', _isDarkMode);
    } catch (_) {}
  }

  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (_) {}
  }

  void toggleProStatus() {
    _isProUnlocked = !_isProUnlocked;
    notifyListeners();
  }

  void incrementScanCount() {
    if (!_isProUnlocked) {
      _dailyScanCount++;
      notifyListeners();
    }
  }

  void resetDailyScans() {
    _dailyScanCount = 0;
    notifyListeners();
  }

  // Folder Taxonomy
  final List<Folder> _folders = [
    Folder(id: 'all', name: 'All Documents', iconKey: 'files'),
    Folder(id: 'assignments', name: 'Assignments', iconKey: 'bookOpen'),
    Folder(id: 'receipts', name: 'Receipts', iconKey: 'receipt'),
    Folder(id: 'personal', name: 'Personal', iconKey: 'user'),
    Folder(id: 'office', name: 'Office', iconKey: 'briefcase'),
  ];
  List<Folder> get folders => _folders;
  
  String _selectedFolderId = 'all';
  String get selectedFolderId => _selectedFolderId;

  void selectFolder(String folderId) {
    _selectedFolderId = folderId;
    notifyListeners();
  }

  void addCustomFolder(String name, String iconKey) {
    final newId = name.toLowerCase().replaceAll(' ', '_');
    _folders.add(Folder(id: newId, name: name, iconKey: iconKey));
    notifyListeners();
  }

  // Documents Library
  final List<Document> _documents = [];
  List<Document> get documents => _documents;

  // Search Filter
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Active Scan Queue (Temporary pages before generation)
  final List<String> _scanQueue = [];
  List<String> get scanQueue => _scanQueue;

  // Mock list of document samples available for simulation
  final List<String> mockDocumentSamples = [
    'assets/illustrations/undraw_my-files_1xwx.svg',
    'assets/illustrations/undraw_file-bundle_oaof.svg',
    'assets/illustrations/File searching-pana.svg',
    'assets/illustrations/Privacy policy-pana.svg',
    'assets/illustrations/Privacy policy-bro.svg',
  ];

  AppState() {
    // Don't seed mock data - library will show real generated PDFs only
  }

  // Get filtered documents based on folder selection and search query
  List<Document> get filteredDocuments {
    return _documents.where((doc) {
      final matchesFolder = _selectedFolderId == 'all' || doc.folderId == _selectedFolderId;
      final matchesSearch = doc.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFolder && matchesSearch;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
  }

  List<Document> get favoriteDocuments {
    return _documents.where((doc) => doc.isFavorite).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Document> get recentDocuments {
    // Return last 10 edited/created documents
    final sorted = List<Document>.from(_documents)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  // Document Operations
  void toggleFavorite(String id) {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(isFavorite: !_documents[index].isFavorite);
      _saveDocuments();
      notifyListeners();
    }
  }

  void deleteDocument(String id) async {
    final doc = _documents.firstWhere((d) => d.id == id, orElse: () => _documents.first);
    
    // Delete PDF file from disk
    if (doc.pdfPath != null) {
      await FileManagerService.deletePdf(doc.pdfPath);
    }
    
    _documents.removeWhere((doc) => doc.id == id);
    _saveDocuments();
    notifyListeners();
  }

  void renameDocument(String id, String newName) async {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      final doc = _documents[index];
      
      // Rename PDF file on disk if it exists
      String? newPdfPath = doc.pdfPath;
      if (doc.pdfPath != null) {
        final renamedPath = await FileManagerService.renamePdf(doc.pdfPath, newName);
        if (renamedPath != null) {
          newPdfPath = renamedPath;
        }
      }
      
      _documents[index] = doc.copyWith(name: newName, pdfPath: newPdfPath);
      _saveDocuments();
      notifyListeners();
    }
  }

  void moveDocumentToFolder(String id, String targetFolderId) {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(folderId: targetFolderId);
      _saveDocuments();
      notifyListeners();
    }
  }

  // Scanner Flow Operations
  void startNewScan() {
    _scanQueue.clear();
    notifyListeners();
  }

  void addPageToScanQueue(String path) {
    _scanQueue.add(path);
    notifyListeners();
  }

  void removePageFromScanQueue(int index) {
    if (index >= 0 && index < _scanQueue.length) {
      _scanQueue.removeAt(index);
      notifyListeners();
    }
  }

  void reorderScanQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _scanQueue.removeAt(oldIndex);
    _scanQueue.insert(newIndex, item);
    notifyListeners();
  }

  void replacePageInScanQueue(int index, String newPath) {
    if (index >= 0 && index < _scanQueue.length) {
      _scanQueue[index] = newPath;
      notifyListeners();
    }
  }

  // Finalize PDF Generation
  Document finalizeScanToDocument({required String name, required String folderId, required double sizeInMb, String? pdfPath}) {
    final newDoc = Document(
      id: _uuid.v4(),
      name: name.isEmpty ? 'ZeScan_${DateTime.now().millisecondsSinceEpoch ~/ 1000}' : name,
      createdAt: DateTime.now(),
      pages: List<String>.from(_scanQueue),
      sizeInMb: sizeInMb,
      folderId: folderId,
      pdfPath: pdfPath,
    );
    _documents.add(newDoc);
    _scanQueue.clear();
    incrementScanCount();
    _saveDocuments(); // Persist to storage
    notifyListeners();
    return newDoc;
  }

  // Toolkit Operations with actual PDF manipulation
  Future<Document> performMerge(List<Document> docsToMerge, String name) async {
    try {
      // Get PDF paths from documents
      final pdfPaths = docsToMerge
          .where((doc) => doc.pdfPath != null && doc.pdfPath!.isNotEmpty)
          .map((doc) => doc.pdfPath!)
          .toList();

      if (pdfPaths.isEmpty) {
        throw Exception('No valid PDFs to merge');
      }

      // Perform actual PDF merge
      final result = await PdfService.mergePdfs(
        pdfPaths: pdfPaths,
        fileName: name.isEmpty ? 'Merged_Document' : name,
      );

      // Create new document with actual PDF
      final newDoc = Document(
        id: _uuid.v4(),
        name: name.isEmpty ? 'Merged_Document' : name,
        createdAt: DateTime.now(),
        pages: List.generate(result.pageCount, (i) => 'page_$i'),
        sizeInMb: result.fileSizeMb,
        folderId: 'all',
        pdfPath: result.filePath,
      );

      _documents.add(newDoc);
      _saveDocuments();
      notifyListeners();
      return newDoc;
    } catch (e) {
      debugPrint('AppState: Merge failed: $e');
      rethrow;
    }
  }

  Future<Document> performCompress(Document doc, double targetQualityMultiplier) async {
    try {
      if (doc.pdfPath == null || doc.pdfPath!.isEmpty) {
        throw Exception('No PDF file to compress');
      }

      // Perform actual PDF compression
      final result = await PdfService.compressPdf(
        sourcePdfPath: doc.pdfPath!,
        fileName: '${doc.name}_compressed',
        quality: targetQualityMultiplier,
      );

      // Create new document with compressed PDF
      final newDoc = doc.copyWith(
        id: _uuid.v4(),
        name: '${doc.name}_compressed',
        createdAt: DateTime.now(),
        sizeInMb: result.fileSizeMb,
        pdfPath: result.filePath,
      );

      _documents.add(newDoc);
      _saveDocuments();
      notifyListeners();
      return newDoc;
    } catch (e) {
      debugPrint('AppState: Compress failed: $e');
      rethrow;
    }
  }

  Future<Document> performSplit(Document doc, List<int> selectedPageIndices, String name) async {
    try {
      if (doc.pdfPath == null || doc.pdfPath!.isEmpty) {
        throw Exception('No PDF file to split');
      }

      // Perform actual PDF split
      final result = await PdfService.splitPdf(
        sourcePdfPath: doc.pdfPath!,
        fileName: name.isEmpty ? '${doc.name}_split' : name,
        pageIndices: selectedPageIndices,
      );

      // Create new document with split PDF
      final newDoc = Document(
        id: _uuid.v4(),
        name: name.isEmpty ? '${doc.name}_split' : name,
        createdAt: DateTime.now(),
        pages: List.generate(result.pageCount, (i) => 'page_$i'),
        sizeInMb: result.fileSizeMb,
        folderId: doc.folderId,
        pdfPath: result.filePath,
      );

      _documents.add(newDoc);
      _saveDocuments();
      notifyListeners();
      return newDoc;
    } catch (e) {
      debugPrint('AppState: Split failed: $e');
      rethrow;
    }
  }

  void performRotatePages(String docId, List<int> pageIndices) {
    // In mock presentation, rotating represents updating file timestamp or updating metadata
    final index = _documents.indexWhere((doc) => doc.id == docId);
    if (index != -1) {
      // simulate edit update
      final doc = _documents[index];
      _documents[index] = doc.copyWith(createdAt: DateTime.now());
      _saveDocuments();
      notifyListeners();
    }
  }

  void performDeletePages(String docId, List<int> pageIndices) {
    final index = _documents.indexWhere((doc) => doc.id == docId);
    if (index != -1) {
      final doc = _documents[index];
      final List<String> updatedPages = List.from(doc.pages);
      // Sort indices descending to avoid shifting issues when deleting
      final sortedIndices = List<int>.from(pageIndices)..sort((a, b) => b.compareTo(a));
      for (var idx in sortedIndices) {
        if (idx >= 0 && idx < updatedPages.length) {
          updatedPages.removeAt(idx);
        }
      }
      if (updatedPages.isEmpty) {
        _documents.removeAt(index);
      } else {
        _documents[index] = doc.copyWith(
          pages: updatedPages,
          sizeInMb: double.parse((doc.sizeInMb * (updatedPages.length / doc.pages.length)).toStringAsFixed(2)),
          createdAt: DateTime.now(),
        );
      }
      _saveDocuments();
      notifyListeners();
    }
  }
}
