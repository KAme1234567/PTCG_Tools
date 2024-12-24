import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InfiniteScrollList extends StatefulWidget {
  @override
  _InfiniteScrollListState createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _items = [];
  bool _isLoading = false;
  int _page = 1;
  final int _limit = 2;

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

    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/items?page=$_page&limit=$_limit')); // 使用局域網 IP

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _items.addAll(data.map((item) {
          return {
            "title": item["title"] as String,
            "thumbnail": item["thumbnail"] as String,
            "description": item["description"] as String
          };
        }).toList());
        _page++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
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
