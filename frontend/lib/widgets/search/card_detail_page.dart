import 'package:flutter/material.dart';

// 卡片詳細頁面
class CardDetailPage extends StatelessWidget {
  final dynamic card;

  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card['name'] ?? 'Card Details'), // 顯示卡片名稱
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              card['image_url'] ?? "https://imgur.com/5Dg33kF",
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              card['name'] ?? 'Unknown Card',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              card['move'] ?? 'No description available.',
              textAlign: TextAlign.center,
            ),
            Text(
              card['effect'] ?? 'No description available.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
