class FeedbackModel {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String msg;
  final String createdAt;
  final String updatedAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.msg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      msg: json['msg'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
