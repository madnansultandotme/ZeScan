class Document {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<String> pages;
  final double sizeInMb;
  final bool isFavorite;
  final String folderId;
  final String? pdfPath; // Absolute path to the generated PDF file on disk

  Document({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.pages,
    required this.sizeInMb,
    this.isFavorite = false,
    required this.folderId,
    this.pdfPath,
  });

  Document copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<String>? pages,
    double? sizeInMb,
    bool? isFavorite,
    String? folderId,
    String? pdfPath,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      pages: pages ?? this.pages,
      sizeInMb: sizeInMb ?? this.sizeInMb,
      isFavorite: isFavorite ?? this.isFavorite,
      folderId: folderId ?? this.folderId,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }
}

class Folder {
  final String id;
  final String name;
  final String iconKey; // Store key corresponding to Lucide icon

  Folder({
    required this.id,
    required this.name,
    required this.iconKey,
  });
}
