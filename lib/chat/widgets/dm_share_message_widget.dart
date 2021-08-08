import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
              // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              // decoration: BoxDecoration(
              //     borderRadius: sendByMe
              //         ? BorderRadius.only(
              //             topLeft: Radius.circular(23),
              //             topRight: Radius.circular(23),
              //             bottomLeft: Radius.circular(23))
              //         : BorderRadius.only(
              //             topLeft: Radius.circular(23),
              //             topRight: Radius.circular(23),
              //             bottomRight: Radius.circular(23)),
              //     gradient: LinearGradient(
              //       colors: sendByMe
              //           ? [
              //               const Color(0xff007EF4).withOpacity(0.8),
              //               const Color(0xff007EF4).withOpacity(0.8)
              //             ]
              //           : [
              //               const Color(0xff000000).withOpacity(0.8),
              //               const Color(0xff000000).withOpacity(0.8)
              //             ],
              //     )),
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
                      child: ShareTile(model: model),
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

class ShareTile extends StatelessWidget {
  const ShareTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ActivityModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.16,
      child: Card(
        elevation: 5,
        color: kPrimaryColor,
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Provider.of<UserProvider>(context)
                                      .getUserImg ==
                                  ''
                              ? NamedProfileAvatar().profileAvatar(
                                  Provider.of<UserProvider>(context)
                                      .getUserName
                                      .substring(0, 1),
                                  80.0)
                              : CachedNetworkImage(
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                  imageUrl: Provider.of<UserProvider>(context)
                                      .getUserImg,
                                  placeholder: (context, url) {
                                    return Center(
                                        child: new SpinKitWave(
                                      type: SpinKitWaveType.start,
                                      size: 20,
                                      color: Colors.black87,
                                    ));
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Text("Creator -"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(model.creatorName)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(Utils.toDate(DateTime.parse(model.startDate))),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Icon(
                        Icons.access_alarm,
                        size: 18,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(Utils.toTime(DateTime.parse(model.startDate))),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
