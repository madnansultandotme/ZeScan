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

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'pages': pages,
      'sizeInMb': sizeInMb,
      'isFavorite': isFavorite,
      'folderId': folderId,
      'pdfPath': pdfPath,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pages: List<String>.from(json['pages'] as List),
      sizeInMb: (json['sizeInMb'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      folderId: json['folderId'] as String,
      pdfPath: json['pdfPath'] as String?,
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
