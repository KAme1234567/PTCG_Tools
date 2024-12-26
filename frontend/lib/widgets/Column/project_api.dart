// frontend\lib\widgets\Column\project_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectAPI {
  static const String baseUrl =
      'https://solely-suitable-titmouse.ngrok-free.app/api'; // 後端 API 的基礎 URL

  // 獲取專欄文章列表
  static Future<List<Map<String, dynamic>>> fetchArticleList() async {
    final url = Uri.parse('$baseUrl/columns');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> articles = json.decode(response.body);
        return articles
            .map((article) => Map<String, dynamic>.from(article))
            .toList();
      } else {
        throw Exception(
            'Failed to load articles. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

  // 根據文章 ID 獲取文章詳細資訊
  static Future<Map<String, dynamic>> fetchArticleDetail(int articleId) async {
    final url = Uri.parse('$baseUrl/columns/$articleId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load article detail. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching article detail: $e');
    }
  }

  // 獲取卡片詳細資訊
  static Future<Map<String, dynamic>> fetchCardDetails(int cardId) async {
    final url = Uri.parse('$baseUrl/cards2/$cardId'); // 使用 ngrok URL

    try {
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true', // 添加標頭跳過警告頁
        },
      );
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load card details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching card details: $e');
    }
  }
}
