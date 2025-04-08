import 'package:example_tabbar2/screens/onboarding_screen.dart';
import 'package:example_tabbar2/viewmodels/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/login_view_model.dart';
import 'viewmodels/bottom_nav_viewmodel.dart';


void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => OnboardingViewModel(), child: OnboardingScreen(),)
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      home: OnboardingScreen(),
    );
  }
}

