import 'package:buddy/user/models/activity_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DmMessageTile extends StatelessWidget {
  final String message;
  final bool isRead;
  final bool sendByMe;

  DmMessageTile({
    required this.message,
    required this.isRead,
    required this.sendByMe,
  });

  @override
  Widget build(BuildContext context) {
    final _fDB = FirebaseDatabase.instance
        .reference()
        .child('Activity')
        .child('-MgGmO2o35M4uv_xPnkI');
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
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
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23))
                      : BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23)),
                  gradient: LinearGradient(
                    colors: sendByMe
                        ? [const Color(0xff007EF4), const Color(0xff007EF4)]
                        : [const Color(0xff000000), const Color(0xff000000)],
                  )),
              child: StreamBuilder<Event>(
                stream: _fDB.onValue,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  final model =
                      ActivityModel.fromMap(snapshot.data.snapshot.value);
                  return Text(model.title);
                },
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
