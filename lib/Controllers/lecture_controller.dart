// controllers/lecture_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../Models/CourseModel.dart';

class LectureController extends GetxController {
  var isLoading = false.obs;
  LectureModel? currentLecture;
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  void playLecture(LectureModel lecture) async {
    isLoading.value = true;
    update();

    currentLecture = lecture;
    lecture.isViewed = true;

    await videoController?.dispose();
    chewieController?.dispose();

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final url = lecture.videoUrl;
      videoController = VideoPlayerController.network(url);
      await videoController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: videoController!.value.aspectRatio,
      );

      videoController!.addListener(() {
        final isPlaying = videoController!.value.isPlaying;
        final isInitialized = videoController!.value.isInitialized;

        if (isPlaying && isInitialized) {
          if (isLoading.value) {
            isLoading.value = false;
            update();
          }
        }
      });
    } catch (e) {
      print('▶️ Error initializing video: $e');
      Get.snackbar("Error", "Failed to load video");
      isLoading.value = false;
      update();
    }
  }

  final storage = const FlutterSecureStorage();

  Future<String?> _getLoggedInUserId() async {
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return userMap['id']?.toString();
    }
    return null;
  }

  Future<void> markProgress({
    int? lectureId,
    int? resourceId,
  }) async {
    try {
      final userId = await _getLoggedInUserId();
      final response = await http.post(
        Uri.parse("https://test.rubicstechnology.com/api/course-progress"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": userId,
          "lecture_id": lectureId,
          "resource_id": resourceId,
        }),
      );

      if (response.statusCode == 200) {
        print("Progress saved successfully");
      } else {
        print("Failed to save progress: ${response.body}");
      }
    } catch (e) {
      print("Error saving progress: $e");
    }
  }

  @override
  void onClose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
