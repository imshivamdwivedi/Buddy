import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/chat/widgets/share_post_tile.dart';
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
    final _corners = 16.0;
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
        //padding: EdgeInsets.only(top: 12, bottom: 17, left: 20, right: 20),
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
          ),
        ),
        child: Column(
          crossAxisAlignment:
              sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 4, left: 10, right: 10, top: 6),
              child: Text(sendBy,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              child: StreamBuilder<Event>(
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
                      child: ShareTile(
                        model: model,
                        sendByMe: sendByMe,
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
            ),
          ],
        ),
      ),
    );
  }
}
