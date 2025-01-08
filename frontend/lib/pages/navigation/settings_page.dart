import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '歡迎來到寶可夢卡牌攻略APP！',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '這款應用旨在為台灣的寶可夢卡牌愛好者提供一個全面的平台，涵蓋以下功能：',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '1. 遊戲規則與基礎教學\n'
              '2. 最新熱門牌組的繁體中文版解析\n'
              '3. 日本道館賽的上位排組與策略分享\n'
              '4. 卡牌交易平台，安全又便捷\n'
              '5. 新彈卡片發行日期查詢，隨時掌握更新',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Text(
              '我們的目標是幫助玩家縮短學習曲線，提升遊戲體驗，'
              '並為台灣的寶可夢卡牌社群創造更多交流和成長的機會。',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
