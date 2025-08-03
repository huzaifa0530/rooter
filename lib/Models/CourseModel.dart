class CourseModel {
  final int id; // ✅ Add this line
  final String title;
  final String description;
  final String thumbnailPath;
  final String instructor;
  final String duration;
  final double rating;
  final int enrolled;
  final List<SectionModel> sections;
  final List<String> resources;

  CourseModel({
    required this.id, // ✅ Add this
    required this.title,
    required this.description,
    required this.thumbnailPath,
    required this.instructor,
    required this.duration,
    this.rating = 0.0,
    this.enrolled = 0,
    this.sections = const [],
    this.resources = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    List<SectionModel> parsedSections = [];
    if (json['sections'] != null) {
      parsedSections = (json['sections'] as List).map((sectionJson) {
        List<LectureModel> lectures = [];
        if (sectionJson['lectures'] != null) {
          lectures = (sectionJson['lectures'] as List).map((lectureJson) {
            return LectureModel(
              title: lectureJson['title'] ?? '',
              videoPath: lectureJson['path'] ?? '',
            );
          }).toList();
        }
        return SectionModel(
          title: sectionJson['title'] ?? '',
          lectures: lectures,
        );
      }).toList();
    }

    List<String> parsedResources = [];
    if (json['resources'] != null) {
      parsedResources = (json['resources'] as List)
          .map((res) => res['file_path'] ?? '')
          .where((path) => path.isNotEmpty)
          .toList()
          .cast<String>();
    }

    return CourseModel(
      id: json['id'], // ✅ Parse the ID here
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailPath: json['thumbnail_path'] ?? '',
      instructor: json['instructor'] ?? '',
      duration: json['duration'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      enrolled: json['enrolled'] ?? 0,
      sections: parsedSections,
      resources: parsedResources,
    );
  }
}

class SectionModel {
  final String title;
  final List<LectureModel> lectures;

  SectionModel({required this.title, required this.lectures});
}

class LectureModel {
  final String title;
  final String videoPath; // Store raw path here
  final bool isDownloaded;
  bool isViewed;

  LectureModel({
    required this.title,
    required this.videoPath,
    this.isDownloaded = false,
    this.isViewed = false,
  });

  String get videoUrl {
    final parts = videoPath.split('/');
    final filename = Uri.encodeComponent(parts.last);
    final directory = parts.sublist(0, parts.length - 1).join('/');
    return 'https://test.rubicstechnology.com/storage/app/public/$directory/$filename';
  }
}
