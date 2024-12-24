import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/Knowledge_page.dart';
import '../pages/Card_page.dart';
import '../pages/Transaction_Page.dart';
import '../pages/settings_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String knowledge = '/knowledge';
  static const String card = '/card';
  static const String transaction = '/transaction';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomePage(),
    knowledge: (context) => Knowledge_page(),
    card: (context) => Card_page(),
    transaction: (context) => Transaction_Page(),
    settings: (context) => SettingsPage(),
  };
}
