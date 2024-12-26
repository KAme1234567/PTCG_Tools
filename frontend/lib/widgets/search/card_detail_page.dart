// frontend\lib\widgets\search\card_detail_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardDetailPage extends StatefulWidget {
  final dynamic card;
  final int cardId;

  const CardDetailPage({super.key, required this.card, required this.cardId});

  @override
  _CardDetailPageState createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  Map<String, dynamic>? card;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCardDetails(); // 初始化時請求數據
  }

  Future<void> fetchCardDetails() async {
    final url =
        'https://solely-suitable-titmouse.ngrok-free.app/api/cards2/${widget.cardId}'; // 使用 ngrok URL
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'ngrok-skip-browser-warning': 'true', // 添加標頭跳過警告頁
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          card = json.decode(response.body); // 解碼 JSON 數據
          isLoading = false;
        });
      } else {
        throw Exception('加載失敗: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加載數據失敗：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (card == null) {
      return const Scaffold(
        body: Center(child: Text('卡片資料加載失敗。')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(card!['name'] ?? '卡詳情況'), // 顯示卡片名稱
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '卡片編號: ${card!['id']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              card!['PTCG_img'] ?? "https://imgur.com/5Dg33kF",
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(card!['stage'] ?? '未查詢到階段'),
                const SizedBox(width: 16),
                Text(
                  card!['name'] ?? '未知卡名',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'HP: ${card!['hp'] ?? '未查詢到HP'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Image.network(
                  card!['attribute_img'] ?? "https://imgur.com/5Dg33kF",
                  height: 25,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 25),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (card!['skills'] != null && card!['skills'] is List)
              ...List<Widget>.generate(
                card!['skills'].length,
                (index) {
                  final skill = card!['skills'][index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill['name'] ?? '未知技能',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: (skill['cost']?.split(',') ?? [])
                            .map<Widget>(
                              (cost) => Image.network(
                                cost,
                                height: 25,
                                errorBuilder: (context, error, stackTrace) {
                                  // 返回一個空的 Container 表示不顯示
                                  return const SizedBox.shrink();
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(skill['damage'] ?? '傷害: 無'),
                      const SizedBox(height: 8),
                      Text(skill['effect'] ?? '描述: 無'),
                      const Divider(),
                    ],
                  );
                },
              ),
            const SizedBox(height: 16), // 添加間距，避免元素擁擠
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '弱點',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                ...((card!['weakness_img']?.split(',') ?? []).map<Widget>(
                  (img) => Image.network(
                    img,
                    height: 25,
                    errorBuilder: (context, error, stackTrace) {
                      // 返回一個空的 Container 表示不顯示
                      return const SizedBox.shrink();
                    },
                  ),
                )),
                Text(
                  card!['weakness'],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '|',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '抵抗',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                ...((card!['resistance_img']?.split(',') ?? []).map<Widget>(
                  (img) => Image.network(
                    img,
                    height: 25,
                    errorBuilder: (context, error, stackTrace) {
                      // 返回一個空的 Container 表示不顯示
                      return const SizedBox.shrink();
                    },
                  ),
                )),
                Text(
                  card!['resistance'],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '|',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '撤退',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                ...((card!['retreat_img']?.split(',') ?? []).map<Widget>(
                  (img) => Image.network(
                    img,
                    height: 25,
                    errorBuilder: (context, error, stackTrace) {
                      // 返回一個空的 Container 表示不顯示
                      return const SizedBox.shrink();
                    },
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
