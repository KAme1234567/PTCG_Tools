import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'card_widget.dart';
import 'card_detail_page.dart';

// 主組件，顯示卡片列表
class PTCGDATAAPI extends StatefulWidget {
  final String name; // 卡片名稱查詢條件
  final String move; // 招式名稱查詢條件

  const PTCGDATAAPI({super.key, this.name = '', this.move = ''});

  @override
  _PTCGDATAAPI createState() => _PTCGDATAAPI();
}

class _PTCGDATAAPI extends State<PTCGDATAAPI> {
  final String apiUrl = 'http://192.168.1.150:8745/api/cards'; // 替換為你的 API 地址
  List<dynamic> cards = []; // 存儲卡片數據的列表
  int currentPage = 1; // 當前頁碼
  bool isLoading = false; // 是否正在加載數據
  bool hasMore = true; // 是否有更多數據

  @override
  void initState() {
    super.initState();
    // 打印接收到的查詢條件
    debugPrint('初始化查詢條件 - 名稱: ${widget.name}, 招式: ${widget.move}');
    fetchCards(); // 初始化時加載卡片數據
  }

  @override
  void didUpdateWidget(covariant PTCGDATAAPI oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 打印新的查詢條件
    debugPrint('更新查詢條件 - 名稱: ${widget.name}, 招式: ${widget.move}');
    // 當查詢條件發生變化時，重新加載數據
    if (oldWidget.name != widget.name || oldWidget.move != widget.move) {
      fetchCards(refresh: true);
    }
  }

  // 從 API 獲取卡片數據
  Future<void> fetchCards({bool refresh = false}) async {
    if (isLoading) return; // 如果正在加載，則返回，避免重複請求
    if (refresh) {
      setState(() {
        currentPage = 1; // 重置頁碼為1
        cards.clear(); // 清空現有數據
        hasMore = true; // 重置是否有更多數據的標誌
      });
    }

    setState(() {
      isLoading = true; // 設置為正在加載
    });

    try {
      // 構建查詢參數
      String queryParams = 'page=$currentPage&limit=12';
      if (widget.name.isNotEmpty) {
        queryParams += '&name=${widget.name}';
      }
      if (widget.move.isNotEmpty) {
        queryParams += '&effect=${widget.move}';
      }

      // 打印完整的 URL
      final String fullUrl = '$apiUrl?$queryParams';
      debugPrint('請求 URL: $fullUrl');

      // 發送 HTTP GET 請求以獲取卡片數據，每次拉取12個卡片
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        // 如果請求成功，解析返回的 JSON 數據
        final List<dynamic> fetchedCards = json.decode(response.body);
        debugPrint('獲取到的卡片數據: $fetchedCards');
        setState(() {
          cards.addAll(fetchedCards); // 添加新獲取的卡片數據到列表中
          currentPage++; // 增加頁碼
          if (fetchedCards.length < 12) {
            hasMore = false; // 如果獲取的數據少於12，表示沒有更多數據
          }
        });
      } else {
        // 如果請求失敗，拋出異常
        throw Exception('加載卡片失敗');
      }
    } catch (e) {
      // 捕獲異常並打印錯誤信息
      debugPrint('加載卡片時出錯: $e');
      // 顯示錯誤提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加載數據失敗。請重試。')),
      );
    } finally {
      setState(() {
        isLoading = false; // 加載完成，設置為不在加載狀態
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => fetchCards(refresh: true), // 下拉刷新功能
        child: cards.isEmpty && isLoading
            ? const Center(child: CircularProgressIndicator()) // 加載中提示
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 每行顯示3個卡片
                    childAspectRatio: 0.7, // 調整卡片比例
                  ),
                  itemCount: cards.length + (hasMore ? 1 : 0), // 顯示更多加載指示
                  itemBuilder: (context, index) {
                    if (index == cards.length) {
                      return const Center(
                          child: CircularProgressIndicator()); // 滾動加載指示
                    }
                    final card = cards[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CardDetailPage(card: card), // 點擊卡片跳轉到詳細頁面
                          ),
                        );
                      },
                      child: CardWidget(card: card), // 使用自定義的卡片顯示組件
                    );
                  },
                ),
              ),
      ),
    );
  }
}
