import 'package:http/http.dart' as http;
import 'dart:convert';

class DeckAPI {
  static const String baseUrl = 'http://192.168.1.150:8745/api';

  // Fetch all decks
  static Future<List<Map<String, dynamic>>> fetchDeckList() async {
    final url = Uri.parse('$baseUrl/decks');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decks = json.decode(response.body);
        return decks.map((deck) => Map<String, dynamic>.from(deck)).toList();
      } else {
        throw Exception(
            'Failed to load decks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching decks: $e');
    }
  }

  // Fetch deck details (list of cards)
  static Future<List<dynamic>> fetchDeckDetails(int deckId) async {
    final url = Uri.parse('$baseUrl/decks/$deckId/cards');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Deck Details Response: ${response.body}');
        return List<dynamic>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load deck details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching deck details: $e');
      throw Exception('Error fetching deck details: $e');
    }
  }

  // Fetch card details
  static Future<Map<String, dynamic>> fetchCardDetails(int cardId) async {
    final url = Uri.parse('$baseUrl/cards2/$cardId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Card Details Response ($cardId): ${response.body}');
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load card details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching card details: $e');
      throw Exception('Error fetching card details: $e');
    }
  }
}
