import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Models/Handbook.dart';
import 'package:rooster/Screen/PdfViewerScreen.dart';
import 'package:rooster/config/api_config.dart';
import 'package:rooster/widgets/VideoPlayerWidget.dart';
import 'package:rooster/widgets/tag_widget.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class HandbookDetailScreen extends StatelessWidget {
  final Handbook handbook;
  const HandbookDetailScreen({super.key, required this.handbook});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            // const Icon(Icons.restaurant_menu, size: 24),
            // const SizedBox(width: 2),
            Text('handbook'.tr),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  handbook.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(Icons.menu_book,
                          size: 50, color: Colors.black45),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              handbook.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              handbook.description,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 24),
            ...handbook.contentBlocks
                .sortedByPosition()
                .map((block) => _buildContentBlock(block)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: handbook.tags
                  .map((tag) => TagWidget(tag: tag, theme: Theme.of(context)))
                  .toList(),
            ),
            const SizedBox(height: 30),
            if (handbook.chefTip != null && handbook.chefTip!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(color: theme.primaryColor.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates_outlined,
                        color: Colors.orange, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        handbook.chefTip!,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContentBlock(HandbookContent block) {
    switch (block.type) {
      case ContentType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            block.data,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        );

      case ContentType.image:
        final imageUrl =
            '${ApiConfig.storageBaseUrl}/${Uri.encodeFull(block.data)}';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/no_image.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

      case ContentType.video:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: VideoPlayerWidget(
            videoUrl: block.data,
            autoPlay: true,
            looping: true,
          ),
        );

      case ContentType.document:
        final fileName = block.data.split('/').last;
        String getFileLabel(String fileName) {
          String lower = fileName.toLowerCase();
          if (lower.endsWith(".pdf")) {
            return "View PDF";
          } else if (lower.endsWith(".doc") || lower.endsWith(".docx")) {
            return "View Word Document";
          } else if (lower.endsWith(".odt") || lower.endsWith(".odt")) {
            return "View Odt Document";
          } else if (lower.endsWith(".xls") || lower.endsWith(".xlsx")) {
            return "View Excel Sheet";
          } else if (lower.endsWith(".ppt") || lower.endsWith(".pptx")) {
            return "View PowerPoint Presentation";
          } else if (lower.endsWith(".jpg") ||
              lower.endsWith(".jpeg") ||
              lower.endsWith(".png")) {
            return "View Image";
          } else {
            return "View File";
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: InkWell(
            onTap: () async {
              if (fileName.toLowerCase().endsWith(".pdf")) {
                Get.to(() => PdfViewerScreen(path: block.data));
              } else {
                // Download and open DOC/DOCX
                try {
                  final dir = await getTemporaryDirectory();
                  final savePath = "${dir.path}/$fileName";

                  // download file
                  await Dio().download(block.data, savePath);

                  // open file
                  await OpenFilex.open(savePath);
                } catch (e) {
                  print("Failed to open file: $e");
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    fileName.toLowerCase().endsWith(".pdf")
                        ? Icons.picture_as_pdf
                        : Icons.insert_drive_file,
                    color: fileName.toLowerCase().endsWith(".pdf")
                        ? Colors.red
                        : Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getFileLabel(
                          fileName), 
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.black45),
                ],
              ),
            ),
          ),
        );
    }
  }
}

extension SortHandbookContent on List<HandbookContent> {
  List<HandbookContent> sortedByPosition() {
    List<HandbookContent> sortedList = [...this];
    sortedList.sort((a, b) => a.position.compareTo(b.position));
    return sortedList;
  }
}

// class VideoBlockWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoBlockWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoBlockWidget> createState() => _VideoBlockWidgetState();
// }

// class _VideoBlockWidgetState extends State<VideoBlockWidget> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 VideoPlayer(_controller),
//                 VideoProgressIndicator(_controller, allowScrubbing: true),
//                 Center(
//                   child: IconButton(
//                     icon: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause_circle
//                           : Icons.play_circle,
//                       size: 64,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play();
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Container(
//             height: 200,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//   }
// }
