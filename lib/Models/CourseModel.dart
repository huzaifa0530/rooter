class CourseModel {
  final int id;
  final String title;
  final String description;
  final String thumbnailPath;
  final String instructor;
  final String duration;
  final double rating;
  final String progress_percentage;
  final int enrolled;
  final List<SectionModel> sections;
  final List<ResourceModel> resources;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailPath,
    required this.instructor,
    required this.duration,
    this.rating = 0.0,
    required this.progress_percentage,
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
              id: lectureJson['id'] ?? 0,
              sectionId: lectureJson['section_id']?.toString() ?? '',
              title: lectureJson['title'] ?? '',
              path: lectureJson['path'] ?? '',
              mediaType: lectureJson['media_type'] ?? '',
              position: lectureJson['position']?.toString() ?? '',
              progress: (lectureJson['progress'] as List? ?? [])
                  .map((p) => ProgressModel.fromJson(p))
                  .toList(),
              isViewed: (lectureJson['progress'] as List? ?? []).isNotEmpty,
            );
          }).toList();
        }
        return SectionModel(
          title: sectionJson['title'] ?? '',
          lectures: lectures,
        );
      }).toList();
    }

    List<ResourceModel> parsedResources = [];
    if (json['resources'] != null) {
      parsedResources = (json['resources'] as List)
          .map((res) => ResourceModel.fromJson(res))
          .toList();
    }

    return CourseModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailPath: json['thumbnail_path'] ?? '',
      instructor: json['instructor'] ?? '',
      duration: json['duration'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      progress_percentage: (json['progress_percentage'] ?? '0.00').toString(),
      enrolled: json['enrolled'] ?? 0,
      sections: parsedSections,
      resources: parsedResources,
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
      title: json['title'] ?? '',
      filePath: json['file_path'] ?? '',
    );
  }
}

class SectionModel {
  final String title;
  final List<LectureModel> lectures;

  SectionModel({required this.title, required this.lectures});
}

class LectureModel {
  final int id;
  final String sectionId;
  final String title;
  final String path;
  final String mediaType;
  final String position;
  final List<ProgressModel> progress;
  bool isViewed;

  LectureModel({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.path,
    required this.mediaType,
    required this.position,
    required this.progress,
    this.isViewed = false,
  });
  String get videoUrl {
    final trimmed = path.trim();
    if (trimmed.toLowerCase().startsWith('http')) return trimmed;

    final pathSegments = <String>[
      'storage',
      'app',
      'public',
      ...trimmed.split('/').where((s) => s.isNotEmpty)
    ];
    final uri = Uri(
      scheme: 'https',
      host: 'test.rubicstechnology.com',
      pathSegments: pathSegments,
    );
    return uri.toString();
  }

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    List<ProgressModel> progressList = [];
    if (json['progress'] != null) {
      progressList = (json['progress'] as List)
          .map((p) => ProgressModel.fromJson(p))
          .toList();
    }

    return LectureModel(
      id: json['id'],
      sectionId: json['section_id'],
      title: json['title'],
      path: json['path'],
      mediaType: json['media_type'],
      position: json['position'],
      progress: progressList,
      isViewed: progressList.isNotEmpty,
    );
  }
}

class ProgressModel {
  final int id;
  final String? lectureId;
  final String? resourceId;
  final String userId;
  final dynamic createdAt;

  ProgressModel({
    required this.id,
    this.lectureId,
    this.resourceId,
    required this.userId,
    this.createdAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'],
      lectureId: json['lecture_id'],
      resourceId: json['resource_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
    );
  }
}
