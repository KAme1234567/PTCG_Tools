import 'package:flutter/material.dart';

import '../../widgets/deck_recommended/deck_api.dart';
import 'project_detail_page.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late Future<List<Map<String, dynamic>>> _decks;

  @override
  void initState() {
    super.initState();
    _decks = DeckAPI.fetchDeckList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('牌組列表')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _decks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('沒有可用的牌組'));
          } else {
            final decks = snapshot.data!;
            return ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                final deck = decks[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(deck['name']),
                    subtitle: Text(deck['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailPage(deckId: deck['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
