import 'package:http/http.dart' as http;
import 'dart:convert';

class SpecialCasesAPI {
  static const String baseUrl =
      'https://solely-suitable-titmouse.ngrok-free.app/api'; // 本地 API 的基礎 URL

  // 獲取特殊判例列表
  static Future<List<Map<String, dynamic>>> fetchSpecialCases() async {
    final url = Uri.parse('$baseUrl/special_cases');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> specialCases = json.decode(response.body);
        return specialCases
            .map((caseData) => Map<String, dynamic>.from(caseData))
            .toList();
      } else {
        throw Exception(
            'Failed to load special cases. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching special cases: $e');
    }
  }

  // 根據 ID 獲取特殊判例詳細資訊
  static Future<Map<String, dynamic>> fetchSpecialCaseDetail(int caseId) async {
    final url = Uri.parse('$baseUrl/special_cases/$caseId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load special case detail. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching special case detail: $e');
    }
  }
}
