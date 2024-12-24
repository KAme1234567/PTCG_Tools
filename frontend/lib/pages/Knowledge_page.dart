import 'package:flutter/material.dart'; // 引入 Material Design 組件庫
import '../widgets/infinite_scroll_list.dart'; // 引入無限滾動組件

class Knowledge_page extends StatelessWidget {
  const Knowledge_page({super.key});

  // 定義一個 KnowledgePage 類，繼承 StatelessWidget
  @override
  Widget build(BuildContext context) {
    // 覆寫 build 方法，構建頁面內容
    return Scaffold(
      // 使用 Scaffold 作為頁面的結構框架
      appBar: AppBar(
        // 添加應用欄
        title: Text('知識頁面'), // 設置應用欄的標題
      ),
      body: Padding(
        // 使用 Padding 添加外邊距
        padding: const EdgeInsets.all(8.0), // 設置所有方向的邊距為 8.0
        child: Column(
          // 使用 Column 將子組件垂直排列
          children: [
            // 定義 Column 的子組件列表
            Card(
              // 使用 Card 作為子組件的容器
              elevation: 4, // 設置卡片的陰影高度
              shape: RoundedRectangleBorder(
                // 設置卡片的形狀
                borderRadius: BorderRadius.circular(12), // 設置圓角半徑為 12
              ),
              child: Container(
                // 使用 Container 包裹卡片內容
                padding: const EdgeInsets.all(16), // 設置卡片內部內容的邊距為 16
                height: 300, // 設置卡片的高度為 300
                child: Column(
                  children: [
                    Text('知識頁面'),
                    SizedBox(height: 16), // 添加間距
                    Expanded(child: InfiniteScrollList()), // 放置無限滾動列表作為卡片內容
                  ],
                ),
              ),
            ),
            SizedBox(height: 16), // 添加垂直間距，高度為 16
            Card(
              // 添加第二個卡片
              elevation: 4, // 設置卡片的陰影高度
              shape: RoundedRectangleBorder(
                // 設置卡片的形狀
                borderRadius: BorderRadius.circular(12), // 設置圓角半徑為 12
              ),
              child: Container(
                // 使用 Container 包裹卡片內容
                padding: const EdgeInsets.all(16), // 設置卡片內部內容的邊距為 16
                height: 150, // 設置卡片的高度為 150
                child: Center(
                  // 將子組件居中對齊
                  child: Text(
                    // 添加文字組件
                    '其他內容', // 顯示的文字內容
                    style: TextStyle(fontSize: 18), // 設置文字的樣式，字體大小為 18
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
