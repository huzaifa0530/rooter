// models/handbook.dart

// models/handbook.dart
enum ContentType { text, image, video, document }

ContentType parseContentType(String type, String data) {
  final ext = data.split('.').last.toLowerCase();

  switch (type.toLowerCase()) {
    case 'image':
      return ContentType.image;
    case 'video':
      return ContentType.video;
    case 'document':
      if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'odt'].contains(ext)) {
        return ContentType.document;
      }
      return ContentType.text;
    default:
      return ContentType.text;
  }
}

class Handbook {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String? chefTip;
  final List<String> tags;
  final List<HandbookContent> contentBlocks;

  Handbook({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    this.chefTip,
    this.tags = const [],
    this.contentBlocks = const [],
  });

  factory Handbook.fromJson(Map<String, dynamic> json) {
    return Handbook(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      chefTip: json['chef_tip'],
      tags: List<String>.from(json['tags'] ?? []),
      contentBlocks: (json['content_blocks'] as List<dynamic>? ?? [])
          .map((e) => HandbookContent.fromJson(e))
          .toList(),
    );
  }
}

class HandbookContent {
  final ContentType type;
  final String data;
  final int position;

  HandbookContent({
    required this.type,
    required this.data,
    required this.position,
  });

  factory HandbookContent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? '';
    final type = json['type'] ?? 'text';

    return HandbookContent(
      type: parseContentType(type, data),
      data: data,
      position: int.tryParse(json['position']?.toString() ?? '0') ?? 0,
    );
  }
}
