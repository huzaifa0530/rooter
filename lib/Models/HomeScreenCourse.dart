class LectureModel {
  final int id;
  final String title;
  final String videoUrl;

  LectureModel({
    required this.id,
    required this.title,
    required this.videoUrl,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Lecture',
      videoUrl: json['video_path'] ?? '',
    );
  }
}

class SectionModel {
  final int id;
  final String title;
  final int position;
  final List<LectureModel> lectures;

  SectionModel({
    required this.id,
    required this.title,
    required this.position,
    required this.lectures,
  });
factory SectionModel.fromJson(Map<String, dynamic> json) {
  final rawLectures = json['lectures'];
  final List<LectureModel> lecturesList = (rawLectures != null && rawLectures is List)
      ? rawLectures.map((e) => LectureModel.fromJson(e)).toList()
      : [];

  return SectionModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? 'Untitled Section',
    position: int.tryParse(json['position']?.toString() ?? '0') ?? 0,
    lectures: lecturesList,
  );
}

}

class ResourceModel {
  final int id;
  final String title;
  final String filePath;

  ResourceModel({
    required this.id,
    required this.title,
    required this.filePath,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Resource',
      filePath: json['file_path'] ?? '',
    );
  }
}

class HomeCourseModel {
  final int id;
  final String title;
  final String description;
  final String instructor;
  final String duration;
  final String thumbnailPath;
  final List<SectionModel> sections;
  final List<ResourceModel> resources;

  HomeCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.thumbnailPath,
    required this.sections,
    required this.resources,
  });

  factory HomeCourseModel.fromJson(Map<String, dynamic> json) {
    List<SectionModel> sectionList = [];
    List<ResourceModel> resourceList = [];

    if (json.containsKey('sections') && json['sections'] is List) {
      sectionList = (json['sections'] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList();
    }

    if (json.containsKey('resources') && json['resources'] is List) {
      resourceList = (json['resources'] as List)
          .map((e) => ResourceModel.fromJson(e))
          .toList();
    }

    return HomeCourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Course',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? 'Unknown Instructor',
      duration: json['duration'] ?? '0h',
      thumbnailPath: json['thumbnail_path'] ?? '',
      sections: sectionList,
      resources: resourceList,
    );
  }
}


