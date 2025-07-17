class LectureModel {
  final String title;
  final String videoUrl;
  final bool isDownloaded;
  bool isViewed;

  LectureModel({
    required this.title,
    required this.videoUrl,
    this.isDownloaded = false,
    this.isViewed = false,
  });
}

class SectionModel {
  final String title;
  final List<LectureModel> lectures;
  SectionModel({required this.title, required this.lectures});
}

class CourseModel {
  final String title;
  final String thumbnailPath;
  final String instructor;
  final double rating; // 0 – 5
  final int enrolled; // student count
  final String duration; // e.g. "4h 30m"
  final List<SectionModel> sections;
  final List<String> resources; // list of asset / URL strings

  CourseModel({
    required this.title,
    required this.thumbnailPath,
    required this.instructor,
    required this.rating,
    required this.enrolled,
    required this.duration,
    required this.sections,
    required this.resources,
  });
}
