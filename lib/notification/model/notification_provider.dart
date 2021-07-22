import 'package:buddy/notification/model/notification_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> allNot = [];

  void setAllNotification(List<NotificationModel> notList) {
    allNot.clear();
    allNot.addAll(notList);
    notifyListeners();
  }

  List<NotificationModel> get allNotification {
    return [...allNot];
  }

  void removeNotification(NotificationModel model) {
    allNot.remove(model);
    notifyListeners();
  }
}
