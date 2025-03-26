import 'package:example_tabbar2/screens/Home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/bottom_nav_viewmodel.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'viewmodels/home_view_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
      ChangeNotifierProvider(create: (_) => CalendarViewModel()),
    ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

