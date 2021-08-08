import 'package:flutter/material.dart';

class DmMessageTile extends StatelessWidget {
  final String message;
  final bool isRead;
  final bool sendByMe;

  DmMessageTile(
      {required this.message, required this.isRead, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    final _corners = 16.0;
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        // left: sendByMe ? 0 : 10,
        // right: sendByMe ? 10 : 0,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(_corners),
                          topRight: Radius.circular(_corners),
                          bottomLeft: Radius.circular(_corners))
                      : BorderRadius.only(
                          topLeft: Radius.circular(_corners),
                          topRight: Radius.circular(_corners),
                          bottomRight: Radius.circular(_corners)),
                  gradient: LinearGradient(
                    colors: sendByMe
                        ? [
                            const Color(0xff007EF4).withOpacity(0.8),
                            const Color(0xff007EF4).withOpacity(0.8)
                          ]
                        : [
                            const Color(0xff000000).withOpacity(0.8),
                            const Color(0xff000000).withOpacity(0.8)
                          ],
                  )),
              child: Text(
                message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
            if (sendByMe && isRead)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Seen'),
                  SizedBox(
                    width: 5,
                  ),
                  // Icon(
                  //   Icons.check,
                  //   color: Colors.black87,
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
