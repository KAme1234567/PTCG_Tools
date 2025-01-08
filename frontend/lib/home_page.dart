import 'package:flutter/material.dart';
import 'widgets/infinite_scroll_list.dart';
import 'pages/Column/project_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PTCDeck',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '最新資訊',
                            style: TextStyle(
                              fontSize: constraints.maxWidth > 600 ? 24 : 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Expanded(child: InfiniteScrollList()),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildNavigationCard(
                        context, '牌組', Icons.filter_none, '/my_decks_page'),
                    _buildNavigationCard(
                        context, '牌組介紹', Icons.description, '/knowledge_page'),
                    _buildNavigationCard(
                        context, '單卡', Icons.crop_portrait, '/search_page'),
                    _buildNavigationCard(
                        context, '專欄介紹', Icons.article, '/project_list_page'),
                    _buildNavigationCard(context, '特殊判例', Icons.gavel,
                        '/special_cases_list_page'),
                    _buildNavigationCard(
                        context, '基本教學', Icons.school, '/basic_rules'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: FractionallySizedBox(
        widthFactor: 0.3,
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Icon(icon, size: 30, color: Theme.of(context).primaryColor),
                  const Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
