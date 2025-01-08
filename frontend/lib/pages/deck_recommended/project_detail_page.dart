import 'package:flutter/material.dart';
import '../../widgets/deck_recommended/deck_api.dart';

class ProjectDetailPage extends StatelessWidget {
  final int deckId;

  const ProjectDetailPage({Key? key, required this.deckId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('牌組詳情'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: DeckAPI.fetchDeckDetails(deckId), // 返回 List<dynamic>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('找不到牌組詳情'));
          } else {
            final cards = snapshot.data!;

            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                final cardId = card['card_id'];
                final cardCount = card['card_count'];

                return FutureBuilder<Map<String, dynamic>>(
                  future: DeckAPI.fetchCardDetails(cardId),
                  builder: (context, cardSnapshot) {
                    if (cardSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('加載中...'),
                      );
                    } else if (cardSnapshot.hasError) {
                      return ListTile(
                        title: Text('發生錯誤: ${cardSnapshot.error}'),
                      );
                    } else if (!cardSnapshot.hasData) {
                      return const ListTile(
                        title: Text('無法獲取卡片資訊'),
                      );
                    } else {
                      final cardDetails = cardSnapshot.data!;
                      final imageUrl = cardDetails['PTCG_img'] ?? '';

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(cardDetails['name'] ?? '未知卡片'),
                          subtitle: Text('數量: $cardCount'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
