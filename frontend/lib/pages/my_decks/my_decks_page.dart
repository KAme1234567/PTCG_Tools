import 'package:flutter/material.dart';
import '../../widgets/SQLite/deck_database.dart';

import 'add_deck_page.dart';
import 'EditDeleteDeckPage.dart';

class MyDecksPage extends StatefulWidget {
  const MyDecksPage({Key? key}) : super(key: key);

  @override
  _MyDecksPageState createState() => _MyDecksPageState();
}

class _MyDecksPageState extends State<MyDecksPage> {
  late Future<List<Map<String, dynamic>>> _decks;

  @override
  void initState() {
    super.initState();
    _decks = DeckDatabase.instance.fetchDecks();
  }

  void _refreshDecks() {
    setState(() {
      _decks = DeckDatabase.instance.fetchDecks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的牌組')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _decks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('目前沒有任何牌組'));
          } else {
            final decks = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: decks.length,
              itemBuilder: (context, index) {
                final deck = decks[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      deck['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      deck['description'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDeleteDeckPage(
                            deckId: deck['id'],
                            initialName: deck['name'],
                            initialDescription: deck['description'],
                          ),
                        ),
                      );
                      if (result == true) {
                        _refreshDecks();
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditDeckPage()),
          );
          if (result == true) {
            _refreshDecks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
