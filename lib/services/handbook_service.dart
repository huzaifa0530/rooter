import 'dart:convert';
import 'package:http/http.dart' as http;

class HandbookService {
  static const String baseUrl = "https://handbuch-rfc.com/api";

  static Future<Map<String, dynamic>> fetchRoot() async {
    final res = await http.get(Uri.parse("$baseUrl/root"));
    if (res.statusCode != 200) throw Exception("Failed to load root");
    return json.decode(res.body);
  }

  static Future<Map<String, dynamic>> fetchCategory(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/category/$id"));
    if (res.statusCode != 200) throw Exception("Failed to load category");
    return json.decode(res.body);
  }
}
