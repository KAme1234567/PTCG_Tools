// frontend\lib\pages\my_decks\EditDeleteDeckPage.dart
import 'package:flutter/material.dart';
import '../../widgets/SQLite/deck_database.dart';
import '../../widgets/SQLite/deck_components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDeleteDeckPage extends StatefulWidget {
  final int deckId;
  final String initialName;
  final String initialDescription;

  const EditDeleteDeckPage({
    Key? key,
    required this.deckId,
    required this.initialName,
    required this.initialDescription,
  }) : super(key: key);

  @override
  _EditDeleteDeckPageState createState() => _EditDeleteDeckPageState();
}

class _EditDeleteDeckPageState extends State<EditDeleteDeckPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Future<List<int>> _cardsInDeck;
  late Map<int, int> _cardCounts = {}; // 初始化為空的 Map
  // 卡片數量對應

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
    _cardsInDeck = DeckDatabase.instance.fetchCardsInDeck(widget.deckId);
    _fetchCardCounts();
  }

  Future<void> _fetchCardCounts() async {
    final cardCounts =
        await DeckDatabase.instance.fetchCardsWithCount(widget.deckId);
    setState(() {
      _cardCounts = cardCounts;
    });
  }

  Future<Map<String, dynamic>> _fetchCardDetails(int cardId) async {
    final url = Uri.parse(
        'https://solely-suitable-titmouse.ngrok-free.app/api/cards2/$cardId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load card details');
    }
  }

  void _updateDeck() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請填寫所有欄位')),
      );
      return;
    }

    await DeckDatabase.instance.addDeck({
      'id': widget.deckId,
      'name': name,
      'description': description,
    });
    Navigator.pop(context, true);
  }

  void _deleteDeck() async {
    await DeckDatabase.instance.deleteDeck(widget.deckId);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯或刪除牌組'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => deck_components(deckId: widget.deckId),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '牌組名稱'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '牌組描述'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateDeck,
                  child: const Text('儲存'),
                ),
                ElevatedButton(
                  onPressed: _deleteDeck,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('刪除'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '牌組中的卡片:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<int>>(
                future: _cardsInDeck,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('發生錯誤: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('目前沒有卡片'));
                  } else {
                    final cards = snapshot.data!;
                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final cardId = cards[index];
                        final count = _cardCounts[cardId] ?? 0;
                        return FutureBuilder<Map<String, dynamic>>(
                          future: _fetchCardDetails(cardId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(title: Text('加載中...'));
                            } else if (snapshot.hasError) {
                              return ListTile(
                                  title: Text('發生錯誤: ${snapshot.error}'));
                            } else {
                              final cardDetails = snapshot.data!;
                              return ListTile(
                                leading: Image.network(
                                  cardDetails['PTCG_img'],
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                                title: Text(cardDetails['name'] ?? '未知卡片'),
                                subtitle: Text('數量: $count'),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
