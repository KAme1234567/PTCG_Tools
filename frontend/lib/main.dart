import 'package:flutter/material.dart';
import 'home_page.dart';
import 'pages/teaching/Knowledge_page.dart';
import 'pages/search/Card_page.dart';
import 'pages/navigation/Transaction_Page.dart';
import 'pages/navigation/settings_page.dart';
import 'widgets/SQLite/deck_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DeckDatabase.deleteDatabaseFile(); // 刪除資料庫
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageNavigator(),
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
    CardPage(),
    HomePage(),
    SettingsPage(),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '資料庫'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}
