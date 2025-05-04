
import 'package:example_tabbar2/screens/Home_screen.dart';
import 'package:example_tabbar2/screens/logins/change_password_screen.dart';
import 'package:example_tabbar2/screens/mypage/mypage_change_password_screen.dart';
import 'package:example_tabbar2/screens/event_content_screen.dart';
import 'package:example_tabbar2/screens/record/history_screen.dart';
import 'package:example_tabbar2/screens/logins/login_screen.dart';
import 'package:example_tabbar2/screens/main_screen.dart';
import 'package:example_tabbar2/screens/mypage/mypage_screen.dart';
import 'package:example_tabbar2/screens/record/image_search_screen.dart';
import 'package:example_tabbar2/screens/record/recording_screen.dart';
import 'package:example_tabbar2/screens/search_screen.dart';
import 'package:example_tabbar2/screens/logins/start_screen.dart';
import 'package:example_tabbar2/viewmodels/announcement_view_model.dart';
import 'package:example_tabbar2/viewmodels/card_flip_view_model.dart';
import 'package:example_tabbar2/viewmodels/event_content_viewmodel.dart';
import 'package:example_tabbar2/viewmodels/logins_viewmodel/change_password_view_model.dart';
import 'package:example_tabbar2/viewmodels/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/image_search_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/user_provider.dart';
import 'screens/mypage/edit_info_screen.dart';
import 'screens/mypage/leave_screen.dart';
import 'screens/logins/onboarding_screen.dart';
import 'viewmodels/mypage_view_model.dart';
import 'viewmodels/home_view_model.dart';
import 'viewmodels/logins_viewmodel/login_view_model.dart';
import 'viewmodels/bottom_nav_viewmodel.dart';
import 'viewmodels/edit_info_view_model.dart';
import 'viewmodels/onboarding_view_model.dart';
import 'viewmodels/mypage_change_password_view_model.dart';
import 'viewmodels/leave_view_model.dart';
import 'viewmodels/history_view_model.dart';
import 'viewmodels/logins_viewmodel/start_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => StartViewModel()),
      ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ChangeNotifierProvider(
        create: (context) => LoginViewModel(
          userProvider: Provider.of<UserProvider>(context, listen: false),
        ),
        child: LoginScreen(),
      ),
      ChangeNotifierProvider(create: (_) => OnboardingViewModel(), child: OnboardingScreen()),
      ChangeNotifierProvider(create: (_) => MyPageViewModel()),
      ChangeNotifierProvider(create: (_) => UserProvider()..loadMockUserData()),
      ChangeNotifierProvider(create: (context) => EditInfoViewModel(context),child: const EditInfoScreen()),
      ChangeNotifierProvider(create: (_) => mypageChangePasswordViewModel(), child: mypageChangePasswordScreen()),
      ChangeNotifierProvider(create: (_) => LeaveViewModel(), child: LeaveScreen()),
      ChangeNotifierProvider(create: (_) => HistoryViewModel()),
      ChangeNotifierProvider(create: (_) => CardFlipViewModel()),
      ChangeNotifierProvider(create: (_) => AnnouncementViewModel()),
      ChangeNotifierProvider(create: (_) => EventContentViewModel()),
      ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()..loadMockUserData(),),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()..loadMockUserData(),),
      ChangeNotifierProxyProvider<UserProvider, StartViewModel>(
        create: (_) => StartViewModel(),
        update: (_, userProvider, startViewModel) =>
        startViewModel!..updateUserProvider(userProvider),
      ),
      ChangeNotifierProxyProvider<UserProvider, LoginViewModel>(
        create: (_) => LoginViewModel(),
        update: (_, userProvider, loginViewModel) =>
        loginViewModel!..updateUserProvider(userProvider),
      ),
      ChangeNotifierProvider(create: (_) => ImageSearchViewModel()),



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
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/recording': (context) => RecordingScreen(),
        // 다른 화면도 여기에 추가 가능
      },
    );
  }
}


