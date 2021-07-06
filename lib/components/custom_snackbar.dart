import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  void showFloatingFlushbar({
    required BuildContext context,
    required String message,
    String title = '',
    required Color color,
  }) {
    Flushbar(
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(5),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      backgroundColor: color,
      /*backgroundGradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.greenAccent.shade400],
          stops: [0.6, 1],
        ),*/
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      animationDuration: Duration(milliseconds: 500),
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: title.isEmpty ? null : title,
      message: message,
    )..show(context);
  }
}
