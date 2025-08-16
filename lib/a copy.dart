import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://test.rubicstechnology.com/api";

class HandbookBrowserScreen extends StatefulWidget {
  const HandbookBrowserScreen({Key? key}) : super(key: key);

  @override
  State<HandbookBrowserScreen> createState() => _HandbookBrowserScreenState();
}

class _HandbookBrowserScreenState extends State<HandbookBrowserScreen> {
  List<Map<String, dynamic>> path = [];
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchRoot();
  }

  Future<Map<String, dynamic>> fetchRoot() async {
    final url = "$baseUrl/root";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception("Failed to load root");
    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> fetchCategory(int id) async {
    final url = "$baseUrl/category/$id";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception("Failed to load category");
    return json.decode(res.body);
  }

  void loadRoot() {
    setState(() {
      path.clear();
      futureData = fetchRoot();
    });
  }

  void loadCategory(int id, String name) {
    setState(() {
      path.add({"id": id, "name": name});
      futureData = fetchCategory(id);
    });
  }

  void goBack() {
    setState(() {
      path.removeLast();
      if (path.isEmpty) {
        futureData = fetchRoot();
      } else {
        final last = path.last;
        futureData = fetchCategory(last["id"]);
      }
    });
  }

  Widget buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (path.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: goBack,
              color: Theme.of(context).primaryColor,
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: loadRoot,
                    child: Text(
                      "Root",
                      style: TextStyle(
                        color: path.isEmpty
                            ? Colors.black
                            : Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (int i = 0; i < path.length; i++) ...[
                    const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          path = path.sublist(0, i + 1);
                          futureData = fetchCategory(path.last["id"]);
                        });
                      },
                      child: Text(
                        path[i]["name"],
                        style: TextStyle(
                          color: i == path.length - 1
                              ? Colors.black
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => loadCategory(category["id"], category["name"]),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Text(
            category["name"] ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHandbookCard(Map<String, dynamic> handbook) {
    final thumbPath = handbook["thumbnail_url"];
    final fullUrl = thumbPath != null && thumbPath.isNotEmpty
        ? "https://test.rubicstechnology.com/storage/app/public/${Uri.encodeComponent(thumbPath)}"
        : null;

    return GestureDetector(
      onTap: () {
        // TODO: Open handbook detail page
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fullUrl != null)
              Image.network(
                fullUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 140,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 140,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              )
            else
              Container(
                height: 140,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                handbook["title"] ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                handbook["description"] ?? "",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📚 Handbook Categories")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            buildBreadcrumb(),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final data = snapshot.data!;
                  final subCats = List<Map<String, dynamic>>.from(data["subCategories"]);
                  final handbooks = List<Map<String, dynamic>>.from(data["handbooks"]);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subCats.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Categories",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subCats.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3 / 2,
                            ),
                            itemBuilder: (context, index) =>
                                buildCategoryCard(subCats[index]),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "📖 Handbooks",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        if (handbooks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "No handbooks linked to this category.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: handbooks.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                     crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.6,
                            ),
                            itemBuilder: (context, index) =>
                                buildHandbookCard(handbooks[index]),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
