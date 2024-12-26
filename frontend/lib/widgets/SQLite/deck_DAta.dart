// frontend\lib\widgets\SQLite\deck_DAta.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'deck_widget.dart';
import 'deck_detail_page.dart';

// 主組件，顯示卡片列表
class PTCGDATAAPI extends StatefulWidget {
  final int deckId;
  final String name; // 卡片名稱查詢條件
  final String move; // 招式名稱查詢條件
  final String stage_filter; // 階段篩選條件
  final String type_filter; // 屬性篩選條件
  final String weakness_filter; // 弱點篩選條件
  final String resistance_filter; // 抵抗力篩選條件
  final String retreat_cost_filter; // 退場所需能量篩選條件
  final int hp_min; // 最低 HP 篩選條件
  final int hp_max; // 最高 HP 篩選條件

  const PTCGDATAAPI({
    super.key,
    required this.deckId,
    this.name = '',
    this.move = '',
    this.stage_filter = '',
    this.type_filter = '',
    this.weakness_filter = '',
    this.resistance_filter = '',
    this.retreat_cost_filter = '',
    this.hp_min = 0,
    this.hp_max = 1000,
  });

  @override
  _PTCGDATAAPI createState() => _PTCGDATAAPI();
}

class _PTCGDATAAPI extends State<PTCGDATAAPI> {
  final String apiUrl =
      'https://solely-suitable-titmouse.ngrok-free.app/api/cards2'; // 替換為你的 API 地址
  List<dynamic> cards = []; // 存儲卡片數據的列表
  int currentPage = 1; // 當前頁碼
  bool isLoading = false; // 是否正在加載數據
  bool hasMore = true; // 是否有更多數據
  @override
  void initState() {
    super.initState();
    // 打印接收到的初始化查詢條件
    debugPrint(
      '初始化查詢條件 - 名稱: ${widget.name}, 招式: ${widget.move}, 階段: ${widget.stage_filter}, 屬性: ${widget.type_filter}, 弱點: ${widget.weakness_filter}, 抵抗力: ${widget.resistance_filter}, 退場所需能量: ${widget.retreat_cost_filter}, HP 範圍: ${widget.hp_min} - ${widget.hp_max}',
    );
    fetchCards(); // 初始化時加載卡片數據
  }

  @override
  void didUpdateWidget(covariant PTCGDATAAPI oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 打印更新後的查詢條件
    debugPrint(
      '更新查詢條件 - 名稱: ${widget.name}, 招式: ${widget.move}, 階段: ${widget.stage_filter}, 屬性: ${widget.type_filter}, 弱點: ${widget.weakness_filter}, 抵抗力: ${widget.resistance_filter}, 退場所需能量: ${widget.retreat_cost_filter}, HP 範圍: ${widget.hp_min} - ${widget.hp_max}',
    );

    // 當篩選條件發生變化時，重新加載數據
    if (oldWidget.name != widget.name ||
        oldWidget.move != widget.move ||
        oldWidget.stage_filter != widget.stage_filter ||
        oldWidget.type_filter != widget.type_filter ||
        oldWidget.weakness_filter != widget.weakness_filter ||
        oldWidget.resistance_filter != widget.resistance_filter ||
        oldWidget.retreat_cost_filter != widget.retreat_cost_filter ||
        oldWidget.hp_min != widget.hp_min ||
        oldWidget.hp_max != widget.hp_max) {
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
        queryParams += '&name=${Uri.encodeComponent(widget.name)}';
      }
      if (widget.move.isNotEmpty) {
        queryParams += '&effect=${Uri.encodeComponent(widget.move)}';
      }
      if (widget.stage_filter.isNotEmpty) {
        queryParams += '&stage=${Uri.encodeComponent(widget.stage_filter)}';
      }
      if (widget.type_filter.isNotEmpty) {
        queryParams += '&type=${Uri.encodeComponent(widget.type_filter)}';
      }
      if (widget.weakness_filter.isNotEmpty) {
        queryParams +=
            '&weakness=${Uri.encodeComponent(widget.weakness_filter)}';
      }
      if (widget.resistance_filter.isNotEmpty) {
        queryParams +=
            '&resistance=${Uri.encodeComponent(widget.resistance_filter)}';
      }
      if (widget.retreat_cost_filter.isNotEmpty) {
        queryParams +=
            '&retreat_cost=${Uri.encodeComponent(widget.retreat_cost_filter)}';
      }
      if (widget.hp_min > 0) {
        queryParams += '&min_hp=${widget.hp_min}';
      }
      if (widget.hp_max < 1000) {
        queryParams += '&max_hp=${widget.hp_max}';
      }

      // 打印完整的 URL
      final String fullUrl = '$apiUrl?$queryParams';
      debugPrint('請求 URL: $fullUrl');

      // 發送 HTTP GET 請求
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'ngrok-skip-browser-warning': 'true', // 添加標頭
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedCards = json.decode(response.body);
        setState(() {
          cards.addAll(fetchedCards); // 添加新獲取的卡片數據到列表中
          currentPage++; // 增加頁碼
          if (fetchedCards.length < 12) {
            hasMore = false; // 如果獲取的數據少於12，表示沒有更多數據
          }
        });
      } else {
        throw Exception('加載卡片失敗');
      }
    } catch (e) {
      debugPrint('加載卡片時出錯: $e');
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
                            builder: (context) => DeckDetailPage(
                              deckId: widget.deckId, // 使用 widget 引用父組件的參數
                              cardId: card['id'], // 從 card 中提取 'id'
                            ),
                            // 點擊卡片跳轉到詳細頁面
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
