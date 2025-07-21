enum ContentType { text, image, video }

class NewsContent {
  final ContentType type;
  final String data;

  NewsContent({required this.type, required this.data});
}

class NewsModel {
  final String title;
  final String shortDescription; // ✅ NEW
  final String description;       // ✅ FULL description
  final String imagePath;
  final DateTime publishedAt;
  final List<NewsContent> contentBlocks;

  NewsModel({
    required this.title,
    required this.shortDescription, // NEW
    required this.description,
    required this.imagePath,
    required this.publishedAt,
    required this.contentBlocks,
  });
}
