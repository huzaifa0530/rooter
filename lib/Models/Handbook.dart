// models/handbook.dart

enum ContentType { image, text, video }

class HandbookContent {
  final ContentType type;
  final String data;

  HandbookContent({required this.type, required this.data});
}

class Handbook {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final List<HandbookContent> contentBlocks;

  Handbook({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.contentBlocks,
  });
}
