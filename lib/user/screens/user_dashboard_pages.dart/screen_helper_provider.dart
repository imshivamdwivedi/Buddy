import 'package:flutter/cupertino.dart';

class ScreenHelperProvider with ChangeNotifier {
  int currentTab = 0;
  bool snackAvail = false;
  String snackPayload = '';

  int get getCurrentTab {
    return currentTab;
  }

  bool get getSnackAvail {
    return snackAvail;
  }

  String get getSnackPayload {
    return snackPayload;
  }

  void flushSnackMessage() {
    snackAvail = false;
    snackPayload = '';
  }

  void setSnackMessage(String payload) {
    snackAvail = true;
    snackPayload = payload;
  }

  void setCurrentTab(int index) {
    currentTab = index;
  }
}
