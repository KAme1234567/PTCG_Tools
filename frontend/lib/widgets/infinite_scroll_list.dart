import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InfiniteScrollList extends StatefulWidget {
  const InfiniteScrollList({super.key});

  @override
  _InfiniteScrollListState createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _items = [];
  bool _isLoading = false;
  int _page = 1;
  final int _limit = 5;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://solely-suitable-titmouse.ngrok-free.app/api/items?page=$_page&limit=$_limit', // ngrok URL
        ),
        headers: {
          'ngrok-skip-browser-warning': 'true', // 添加標頭
        },
      );

      if (response.statusCode == 200) {
        final decodedData = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedData);
        if (mounted) {
          // 確保 widget 未被移除
          setState(() {
            _items.addAll(data.map((item) {
              return {
                "title": item["title"] as String,
                "thumbnail": item["thumbnail"] as String,
                "description": item["description"] as String
              };
            }).toList());
            _page++;
          });
        }
      } else {
        if (mounted) {
          // 確保 widget 未被移除
          setState(() {
            _isLoading = false;
          });
        }
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        // 確保 widget 未被移除
        setState(() {
          _isLoading = false;
        });
      }
      rethrow;
    } finally {
      if (mounted) {
        // 確保 widget 未被移除
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + 1,
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return _isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }
        final item = _items[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  item["thumbnail"]!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item["description"]!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
