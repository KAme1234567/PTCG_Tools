// E:\Projects\PTCG_Tools\frontend\lib\widgets\search\card_widget.dart
import 'package:flutter/material.dart';

// 自定義卡片顯示組件
class CardWidget extends StatelessWidget {
  final dynamic card;

  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              card['PTCG_img'] ?? "https://imgur.com/5Dg33kF", // 動態圖片 URL 或預設圖片
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50), // 處理圖片加載錯誤
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     card['name'] ?? 'Unknown Card', // 顯示卡片名稱
          //     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //     textAlign: TextAlign.center,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
        ],
      ),
    );
  }
}
