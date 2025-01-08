import 'package:flutter/material.dart';
import 'home_page.dart';
import 'pages/teaching/knowledge_page.dart';
import 'pages/search/card_page.dart';
import 'pages/navigation/settings_page.dart';

import 'pages/Column/project_list_page.dart'; // 假設的頁面
import 'pages/Jurisprudence/special_cases_list_page.dart'; // 假設的頁面
import 'pages/my_decks/my_decks_page.dart'; // 假設的頁面
import 'pages/teaching/basic_rules.dart'; // 假設的頁面
import 'package:flutter_ptcg/pages/deck_recommended/project_list_page.dart'
    as recommended;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DeckDatabase.deleteDatabaseFile(); // 如果需要刪除資料庫，解除註解此行
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePageNavigator(),
        '/my_decks_page': (context) => const MyDecksPage(),
        '/knowledge_page': (context) => const recommended.ProjectListPage(),
        '/search_page': (context) => const CardPage(),
        '/project_list_page': (context) => recommended.ProjectListPage(),
        '/special_cases_list_page': (context) => const SpecialCasesListPage(),
        '/basic_rules': (context) => const BasicRules(),
      },
    );
  }
}

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  _HomePageNavigatorState createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    const CardPage(),
    const HomePage(),
    const IntroductionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '資料庫'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '介紹'),
        ],
      ),
    );
  }
}
