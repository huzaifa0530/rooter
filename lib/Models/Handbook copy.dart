// models/Handbook.dart

enum ContentType { text, image, video }

ContentType parseContentType(String type) {
  switch (type) {
    case 'image':
      return ContentType.image;
    case 'video':
      return ContentType.video;
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
      title: json['title'],
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      chefTip: json['chef_tip'],
      tags: List<String>.from(json['tags'] ?? []),
      contentBlocks: (json['content_blocks'] as List<dynamic>?)
              ?.map((e) => HandbookContent.fromJson(e))
              .toList() ??
          [],
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
    return HandbookContent(
      type: parseContentType(json['type']),
      data: json['data'] ?? '',
      position: int.tryParse(json['position']?.toString() ?? '0') ?? 0,
    );
  }
}
