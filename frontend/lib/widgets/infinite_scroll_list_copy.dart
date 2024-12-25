import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardsDisplay extends StatefulWidget {
  @override
  _CardsDisplayState createState() => _CardsDisplayState();
}

class _CardsDisplayState extends State<CardsDisplay> {
  final String apiUrl = 'http://127.0.0.1:8000/api/cards'; // 替換為你的 API 地址
  List<dynamic> cards = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('$apiUrl?page=$currentPage&limit=12')); // 每次拉取12個卡片
      if (response.statusCode == 200) {
        final List<dynamic> fetchedCards = json.decode(response.body);
        setState(() {
          cards.addAll(fetchedCards);
          currentPage++;
          if (fetchedCards.length < 12) {
            hasMore = false; // 如果數量少於12，表示沒有更多數據
          }
        });
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      debugPrint('Error fetching cards: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cards.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator()) // 加載中提示
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    hasMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  fetchCards(); // 滾動到底部加載更多
                }
                return false;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 每行顯示3個卡片
                  childAspectRatio: 0.7, // 調整卡片比例
                ),
                itemCount: cards.length + (hasMore ? 1 : 0), // 顯示更多加載指示
                itemBuilder: (context, index) {
                  if (index == cards.length) {
                    return Center(child: CircularProgressIndicator()); // 滾動加載指示
                  }
                  final card = cards[index];
                  return CardWidget(card: card); // 使用自定義的卡片顯示組件
                },
              ),
            ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final dynamic card;

  const CardWidget({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              "https://down-tw.img.susercontent.com/file/tw-11134207-7r98p-ltev3gcn4d8of9", // 使用 API 返回的圖片 URL

              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 50), // 處理圖片加載錯誤
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              card['name'], // 顯示卡片名稱
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
