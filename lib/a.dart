// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../Models/NewsModel.dart';

// class NewsDetailScreen extends StatelessWidget {
//   final NewsModel news;

//   const NewsDetailScreen({super.key, required this.news});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ROOSTER'),
//         backgroundColor: theme.primaryColor,
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // 🖼️ Header Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(14),
//               child: Image.asset(
//                 news.imagePath,
//                 fit: BoxFit.cover,
//                 height: 220,
//                 width: double.infinity,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 📰 Title
//             Text(
//               news.title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),

//             // 📝 Short description
//             Text(
//               news.shortDescription,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),

//             // 📅 Date
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                 const SizedBox(width: 6),
//                 Text(
//                   DateFormat.yMMMMd().format(news.publishedAt),
//                   style: const TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // 🏷️ Tags/Chips
//             Wrap(
//               spacing: 8,
//               children: [
//                 _buildChip('ROOSTER Update', theme),
//                 _buildChip('Food Offers', theme),
//                 _buildChip('Branch News', theme),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // 📦 Content Blocks (Image/Video + description)
//             ..._buildContentBlocks(news.contentBlocks),

//             const SizedBox(height: 30),

//             // 💡 Footer
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: const [
//                   Text(
//                     'Did you enjoy this update?',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     'Share it with your friends or visit your nearest ROOSTER location today!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🧱 Content Block Renderer
//   List<Widget> _buildContentBlocks(List<NewsContent> blocks) {
//     final List<Widget> widgets = [];
//     int i = 0;

//     while (i < blocks.length) {
//       final block = blocks[i];

//       if (block.type == ContentType.image || block.type == ContentType.video) {
//         // Media
//         widgets.add(
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: block.type == ContentType.image
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       block.data,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '🎥 Video Preview',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           'assets/images/no_image.jpg',
//                           height: 180,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         'Video: ${block.data.split('/').last}',
//                         style: const TextStyle(fontSize: 14, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//           ),
//         );

//         // description after media
//         if (i + 1 < blocks.length && blocks[i + 1].type == ContentType.text) {
//           widgets.add(
//             Padding(
//               padding: const EdgeInsets.only(bottom: 24, top: 4),
//               child: Text(
//                 blocks[i + 1].data,
//                 style: const TextStyle(fontSize: 16, height: 1.6),
//               ),
//             ),
//           );
//           i += 2;
//         } else {
//           i++;
//         }
//       } else {
//         i++;
//       }
//     }

//     return widgets;
//   }

//   /// 🔖 Reusable Chip Builder
//   Widget _buildChip(String label, ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: theme.primaryColor.withOpacity(0.6), width: 1),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.local_fire_department, size: 16, color: theme.primaryColor),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: theme.primaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
