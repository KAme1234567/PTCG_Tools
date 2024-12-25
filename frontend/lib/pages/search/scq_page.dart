import 'package:flutter/material.dart';
import 'package:flutter_ptcg/widgets/infinite_scroll_list_copy.dart';

class ScqPage extends StatefulWidget {
  const ScqPage({super.key});

  @override
  _ScqPageState createState() => _ScqPageState();
}

class _ScqPageState extends State<ScqPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '單卡查詢',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '輸入卡片名稱',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 搜索按鈕的操作
                  },
                  child: Icon(Icons.search),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 篩選按鈕的操作
                  },
                  child: Icon(Icons.filter_list),
                ),
              ],
            ),
            SizedBox(height: 16), // 添加間距
            Expanded(
              child: Center(
                child: Expanded(
                  child: CardsDisplay(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
