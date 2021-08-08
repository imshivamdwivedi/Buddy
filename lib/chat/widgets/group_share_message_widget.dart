import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GroupShareMessageTile extends StatelessWidget {
  final String message;
  final String sendBy;
  final bool sendByMe;

  GroupShareMessageTile({
    required this.message,
    required this.sendBy,
    required this.sendByMe,
  });

  @override
  Widget build(BuildContext context) {
    final _fDB =
        FirebaseDatabase.instance.reference().child('Activity').child(message);
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
            sendByMe ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
        padding: EdgeInsets.only(top: 12, bottom: 17, left: 20, right: 20),
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
                  ? [
                      const Color(0xff007EF4).withOpacity(0.8),
                      const Color(0xff007EF4).withOpacity(0.8)
                    ]
                  : [
                      const Color(0xff000000).withOpacity(0.8),
                      const Color(0xff000000).withOpacity(0.8)
                    ],
            )),
        child: Column(
          crossAxisAlignment:
              sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(sendBy,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            StreamBuilder<Event>(
              stream: _fDB.onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final model =
                      ActivityModel.fromMap(snapshot.data.snapshot.value);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetailScreen(activityModel: model),
                        ),
                      );
                    },
                    child: Text(
                      'POST TITLE = ${model.title}\nLike And Subscribe !',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  );
                } else {
                  return Text(
                    'Loading...',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
