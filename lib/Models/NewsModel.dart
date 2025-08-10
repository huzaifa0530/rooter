
class NewsModel {
  final int id;
  final String title;
  final String description;
  final String imagePath;
  final DateTime publishedAt;
  final List<NewsContent> contentBlocks;
  final List<String> tags;

  String get shortDescription {
    return description.length > 80
      ? '${description.substring(0, 80)}...'
      : description;
  }

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.publishedAt,
    required this.contentBlocks,
    required this.tags,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final List<String> tagsList = (rawTags != null && rawTags is List)
      ? rawTags.map((t) => (t['name'] ?? '').toString()).toList()
      : [];

    final rawSections = json['sections'];
    final List<NewsContent> contentList = (rawSections != null && rawSections is List)
      ? rawSections.map((b) => NewsContent.fromJson(b)).toList()
      : [];

    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['image_path'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
      tags: tagsList,
      contentBlocks: contentList,
    );
  }
}

enum ContentType { image, video, text }
class NewsContent {
  final ContentType type;
  final String mediaPath;    
  final String description;  

  NewsContent({
    required this.type,
    required this.mediaPath,
    required this.description,
  });

  factory NewsContent.fromJson(Map<String, dynamic> json) {
    ContentType type = ContentType.text;
    if (json['media_type'] == 'image') {
      type = ContentType.image;
    } else if (json['media_type'] == 'video') {
      type = ContentType.video;
    }

    return NewsContent(
      type: type,
      mediaPath: json['media_path'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
