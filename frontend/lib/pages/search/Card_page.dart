import 'package:flutter/material.dart';
import 'scq_page.dart';
import '../teaching/Knowledge_page.dart';
import '../Column/project_list_page.dart';
import '../Jurisprudence/special_cases_list_page.dart';
import '../my_decks/my_decks_page.dart';
import '../teaching/basic_rules.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '查詢頁面',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, // 每行兩個按鈕
          crossAxisSpacing: 10.0, // 按鈕之間的橫向間距
          mainAxisSpacing: 10.0, // 按鈕之間的縱向間距
          children: _buildButtons(context),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final buttons = [
      {
        'icon': Icons.filter_none,
        'label': '牌組',
        'page': const MyDecksPage(),
      },
      {
        'icon': Icons.description,
        'label': '牌組介紹',
        'page': const Knowledge_page(),
      },
      {
        'icon': Icons.crop_portrait,
        'label': '單卡',
        'page': const SearchPage(),
      },
      {
        'icon': Icons.article,
        'label': '專欄介紹',
        'page': const ProjectListPage(),
      },
      {
        'icon': Icons.gavel,
        'label': '特殊判例',
        'page': const SpecialCasesListPage(),
      },
      {
        'icon': Icons.school,
        'label': '基本教學',
        'page': const BasicRules(),
      },
    ];

    return buttons.map((button) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => button['page'] as Widget),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(button['icon'] as IconData,
                    size: 50, color: Theme.of(context).primaryColor),
                SizedBox(height: 10),
                Text(
                  button['label'] as String,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
