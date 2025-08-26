import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String path;
  const PdfViewerScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final bool isNetwork = path.startsWith('http');

    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: isNetwork
          ? SfPdfViewer.network(
              path,
              onDocumentLoadFailed: (details) {
                debugPrint('🌐 PDF Load Failed (Network): ${details.error}');
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load PDF: ${details.error}')),
                );

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Load Failed'),
                    content: Text('Could not load network PDF:\n${details.error}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            )
          : SfPdfViewer.asset(
              path,
              onDocumentLoadFailed: (details) {
                debugPrint('📁 PDF Load Failed (Asset): ${details.error}');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load PDF: ${details.error}')),
                );

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Load Failed'),
                    content: Text('Could not load local asset PDF:\n${details.error}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
