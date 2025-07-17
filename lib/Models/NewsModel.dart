// models/news_model.dart
class NewsModel {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String imagePath;
  final DateTime publishedAt;

  NewsModel({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.imagePath,
    required this.publishedAt,
  });
}
