class Handbook {
  final String id;
  final String title;
  final String description;
  final String content;
  final String thumbnailUrl;

  Handbook({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.thumbnailUrl,
  });

  factory Handbook.fromJson(Map<String, dynamic> json) => Handbook(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        content: json['content'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
      );
}