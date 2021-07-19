import 'package:buddy/notification/model/notification_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> notifications = [];

  void setAllNotification(List<NotificationModel> notList) {
    notifications.clear();
    notifications.addAll(notList);
    notifyListeners();
  }

  List<NotificationModel> get allNotification {
    return [...notifications];
  }

  void removeNotification(NotificationModel model) {
    notifications.remove(model);
    notifyListeners();
  }
}
