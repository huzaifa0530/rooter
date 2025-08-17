class ApiConfig {
  static const String baseUrl = "https://handbuch-rfc.com/api";
  static const String storageBaseUrl = "https://handbuch-rfc.com/storage/app/public";
  // 🔹 Auth
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";

  // 🔹 Feedback
  static const String feedback = "$baseUrl/feedback";

  // 🔹 News
  static const String newsList = "$baseUrl/news";
  static String newsById(int id) => "$baseUrl/news/$id";

  // 🔹 Courses
  static String courseById(int id) => "$baseUrl/courses/$id";
  static String userCourses(int courseId, int userId) =>
      "$baseUrl/courses/$courseId/$userId";
  static String coursesList(int userId) => "$baseUrl/courses/list/$userId";
  static const String courseProgress = "$baseUrl/course-progress";

  // 🔹 Handbooks
  static String handbookById(int id) => "$baseUrl/handbooks/$id";

  // 🔹 Root & Category (from HandbookService)
  static const String root = "$baseUrl/root";
  static String category(int id) => "$baseUrl/category/$id";

  // 🔹 Home
  static String homeData(int userId) => "$baseUrl/home/$userId";
}
