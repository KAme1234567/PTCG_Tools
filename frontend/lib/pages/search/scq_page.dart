import 'package:flutter/material.dart';
import '../../widgets/search/PTCG_DATA_API.dart'; // 導入 PTCG_DATA_API 組件

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final nameFocusNode = FocusNode(); // 名稱輸入框焦點
  final moveFocusNode = FocusNode(); // 招式輸入框焦點

  final nameController = TextEditingController(); // 名稱搜索框控制器
  final moveController = TextEditingController(); // 招式搜索框控制器

  @override
  void dispose() {
    // 清理資源
    nameFocusNode.dispose();
    moveFocusNode.dispose();
    nameController.dispose();
    moveController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    // 清除所有焦點，避免 DOM 與 Flutter 焦點不一致
    FocusScope.of(context).unfocus();
    // 打印當前的查詢條件
    debugPrint('查詢條件 - 名稱: ${nameController.text}, 招式: ${moveController.text}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PTCG Cards'), // 應用標題
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: nameFocusNode,
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '輸入卡片名稱',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    focusNode: moveFocusNode,
                    controller: moveController,
                    decoration: InputDecoration(
                      hintText: '輸入招式名稱',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearchPressed,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // 添加間距
          Expanded(
            child: PTCGDATAAPI(
              name: nameController.text,
              move: moveController.text,
            ),
          ),
        ],
      ),
    );
  }
}
