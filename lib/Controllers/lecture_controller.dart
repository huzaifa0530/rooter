// controllers/lecture_controller.dart
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
  update(); // Show loader immediately

  currentLecture = lecture;
  lecture.isViewed = true;

  // Dispose previous controllers
  await videoController?.dispose();
  chewieController?.dispose();

  try {
    // Slight delay to give UI time to show the loader
    await Future.delayed(const Duration(milliseconds: 100));

    videoController = VideoPlayerController.network(lecture.videoUrl);
    await videoController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController!,
      autoPlay: true,
      looping: false,
      aspectRatio: videoController!.value.aspectRatio,
    );

    // Listen when video really starts playing
    videoController!.addListener(() {
      final isPlaying = videoController!.value.isPlaying;
      final isInitialized = videoController!.value.isInitialized;

      if (isPlaying && isInitialized) {
        if (isLoading.value) {
          isLoading.value = false;
          update(); // Hide loader now
        }
      }
    });

  } catch (e) {
    Get.snackbar("Error", "Failed to load video");
    isLoading.value = false;
    update();
  }
}


  @override
  void onClose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}
