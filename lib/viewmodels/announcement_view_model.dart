import 'package:flutter/material.dart';

class AnnouncementViewModel extends ChangeNotifier {
  void navigateToBackPage(BuildContext context) {
    Navigator.pop(context);
  }
}
