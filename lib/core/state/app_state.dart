import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document.dart';

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
    } catch (_) {
      _isDarkMode = true;
      _isOnboardingCompleted = false;
    }
    _isInitialized = true;
    notifyListeners();
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
    _seedInitialData();
  }

  void _seedInitialData() {
    _documents.addAll([
      Document(
        id: 'doc-1',
        name: 'Maths_Assignment_1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        pages: List.generate(4, (i) => mockDocumentSamples[i % mockDocumentSamples.length]),
        sizeInMb: 1.8,
        isFavorite: true,
        folderId: 'assignments',
      ),
      Document(
        id: 'doc-2',
        name: 'Grocery_Receipt_June',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        pages: [mockDocumentSamples[1]],
        sizeInMb: 0.45,
        isFavorite: false,
        folderId: 'receipts',
      ),
      Document(
        id: 'doc-3',
        name: 'Apartment_Lease_2026',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        pages: List.generate(12, (i) => mockDocumentSamples[i % mockDocumentSamples.length]),
        sizeInMb: 5.4,
        isFavorite: true,
        folderId: 'personal',
      ),
      Document(
        id: 'doc-4',
        name: 'ZeScan_Pitch_Deck',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        pages: List.generate(20, (i) => mockDocumentSamples[i % mockDocumentSamples.length]),
        sizeInMb: 11.2,
        isFavorite: false,
        folderId: 'office',
      ),
    ]);
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
      notifyListeners();
    }
  }

  void deleteDocument(String id) {
    _documents.removeWhere((doc) => doc.id == id);
    notifyListeners();
  }

  void renameDocument(String id, String newName) {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(name: newName);
      notifyListeners();
    }
  }

  void moveDocumentToFolder(String id, String targetFolderId) {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(folderId: targetFolderId);
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
    notifyListeners();
    return newDoc;
  }

  // Simulated Toolkit Operations
  Document performMerge(List<Document> docsToMerge, String name) {
    final List<String> combinedPages = [];
    double combinedSize = 0;
    
    for (var doc in docsToMerge) {
      combinedPages.addAll(doc.pages);
      combinedSize += doc.sizeInMb;
    }

    final newDoc = Document(
      id: _uuid.v4(),
      name: name.isEmpty ? 'Merged_Document' : name,
      createdAt: DateTime.now(),
      pages: combinedPages,
      sizeInMb: double.parse((combinedSize * 0.9).toStringAsFixed(2)), // simulated 10% structural optimization merge size
      folderId: 'all',
    );
    _documents.add(newDoc);
    notifyListeners();
    return newDoc;
  }

  Document performCompress(Document doc, double targetQualityMultiplier) {
    // Quality compression simulation
    final compressedSize = double.parse((doc.sizeInMb * targetQualityMultiplier).toStringAsFixed(2));
    final newDoc = doc.copyWith(
      id: _uuid.v4(),
      name: '${doc.name}_compressed',
      createdAt: DateTime.now(),
      sizeInMb: compressedSize,
    );
    _documents.add(newDoc);
    notifyListeners();
    return newDoc;
  }

  Document performSplit(Document doc, List<int> selectedPageIndices, String name) {
    final List<String> splitPages = [];
    for (var index in selectedPageIndices) {
      if (index >= 0 && index < doc.pages.length) {
        splitPages.add(doc.pages[index]);
      }
    }
    
    final newDoc = Document(
      id: _uuid.v4(),
      name: name.isEmpty ? '${doc.name}_split' : name,
      createdAt: DateTime.now(),
      pages: splitPages,
      sizeInMb: double.parse((doc.sizeInMb * (splitPages.length / doc.pages.length)).toStringAsFixed(2)),
      folderId: doc.folderId,
    );
    _documents.add(newDoc);
    notifyListeners();
    return newDoc;
  }

  void performRotatePages(String docId, List<int> pageIndices) {
    // In mock presentation, rotating represents updating file timestamp or updating metadata
    final index = _documents.indexWhere((doc) => doc.id == docId);
    if (index != -1) {
      // simulate edit update
      final doc = _documents[index];
      _documents[index] = doc.copyWith(createdAt: DateTime.now());
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
      notifyListeners();
    }
  }
}
