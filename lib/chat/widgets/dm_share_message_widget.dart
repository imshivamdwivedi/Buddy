import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DmShareMessageTile extends StatelessWidget {
  final String message;
  final bool isRead;
  final bool sendByMe;

  DmShareMessageTile({
    required this.message,
    required this.isRead,
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
