import 'package:flutter/material.dart'; // 引入 Material Design 組件庫
import 'widgets/infinite_scroll_list.dart'; // 引入無限滾動組件

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PTCDeck', // 設置應用欄的標題並居中
            style: TextStyle(fontSize: 32), // 設置文字的樣式，字體大小為 32
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // 設置所有方向的邊距為 8.0
        child: Column(
          children: [
            // 資訊卡片
            Expanded(
              child: Card(
                elevation: 4, // 設置卡片的陰影高度
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // 設置圓角半徑為 12
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      padding: const EdgeInsets.all(16), // 設置卡片內部內容的邊距為 16
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height *
                            0.4, // 設置最大高度為螢幕高度的 40%
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '最新資訊',
                            style: TextStyle(
                              fontSize: constraints.maxWidth > 600
                                  ? 24
                                  : 20, // 根據螢幕寬度調整字體大小
                            ),
                          ),
                          SizedBox(height: 16), // 添加間距
                          Divider(), // 添加分割線
                          SizedBox(height: 16), // 添加間距
                          Expanded(
                              child: InfiniteScrollList()), // 放置無限滾動列表作為卡片內容
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16), // 添加垂直間距，高度為 16
            // 導航卡片
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                    spacing: 16, // 卡片之間的水平間距
                    runSpacing: 4, // 卡片之間的垂直間距
                    alignment: WrapAlignment.center, // 卡片居中對齊
                    children: [
                      _buildNavigationCard(
                          context, '競技綜覽', Icons.sports_esports, '/page1'),
                      _buildNavigationCard(
                          context, '專欄介紹', Icons.menu_book, '/page2'),
                      _buildNavigationCard(
                          context, '消息通知', Icons.notifications, '/page3'),
                      _buildNavigationCard(
                          context, '我的牌組', Icons.style, '/page4'),
                      _buildNavigationCard(
                          context, '最新判例', Icons.gavel, '/page5'),
                      _buildNavigationCard(
                          context, '相關網站', Icons.link, '/page6'),
                    ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 構建導航卡片
  Widget _buildNavigationCard(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route); // 點擊卡片時導航到指定路由
      },
      child: FractionallySizedBox(
        widthFactor: 0.3, // 設置卡片的寬度占容器的比例（30%）
        child: AspectRatio(
          aspectRatio: 1, // 設置卡片為正方形
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 設置圓角
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // 水平方向居中
                children: [
                  Spacer(),
                  Icon(icon,
                      size: 30,
                      color: Theme.of(context).primaryColor), // 圖標在正中央
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold), // 標題文字樣式
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
