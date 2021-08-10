import 'dart:math' as math;

import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/chat/screens/share_posts.dart';
import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/widgets/comments_view_screen.dart';
import 'package:buddy/utils/dynamci_link_service.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class ActivityItem extends StatefulWidget {
  final ActivityModel dataModel;

  ActivityItem({required this.dataModel});

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  void addEvent() async {
    final uid = _auth.currentUser!.uid;
    final activityId = widget.dataModel.id;

    final _refUserEvent = _firebaseDatabase
        .reference()
        .child('Events')
        .child(uid)
        .child(activityId);
    await _refUserEvent.child('eid').set(activityId);
  }

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.parse(widget.dataModel.startDate);
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(children: [
        buildUpperPart(dateTime, size),
      ]),
    );
  }

  Widget buildUpperPart(var dateTime, Size size) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                    activityModel: widget.dataModel,
                  )),
        );
      },
      child: Container(
        child: Card(
            elevation: 5,
            color: kPrimaryColor,
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
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
                            child: widget.dataModel.img == ''
                                ? NamedProfileAvatar().profileAvatar(
                                    widget.dataModel.title
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    80.0,
                                  )
                                : CachedNetworkImage(
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.cover,
                                    imageUrl: widget.dataModel.img,
                                    placeholder: (context, url) {
                                      return Center(
                                        child: new SpinKitWave(
                                          type: SpinKitWaveType.start,
                                          size: 20,
                                          color: Colors.black87,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return NamedProfileAvatar().profileAvatar(
                                        widget.dataModel.title
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        80.0,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  widget.dataModel.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat.yMMMEd().format(dateTime),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Icon(Icons.access_time),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat.Hm().format(dateTime),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  color: kPrimaryLightColor,
                  height: size.height * 0.08,
                  padding: EdgeInsets.only(
                      left: size.width * 0.03, right: size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileFloatingButton(
                        color: Colors.black,
                        icon: Icons.comment,
                        iconColor: Colors.white,
                        iconSize: 20,
                        height: 35,
                        width: 35,
                        OnPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentViewScreen(
                                    dataModel: widget.dataModel)),
                          );
                        },
                      ),
                      Transform.rotate(
                        angle: -math.pi / 4,
                        child: ProfileFloatingButton(
                          color: Colors.black,
                          icon: Icons.send,
                          iconColor: Colors.white,
                          iconSize: 20,
                          height: 35,
                          width: 35,
                          OnPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SharePost(
                                        postId: widget.dataModel.id,
                                      )),
                            );
                          },
                        ),
                      ),
                      ProfileFloatingButton(
                        color: Colors.black,
                        icon: Icons.add,
                        iconColor: Colors.white,
                        iconSize: 20,
                        height: 35,
                        width: 35,
                        OnPressed: addEvent,
                      ),
                      ProfileFloatingButton(
                        color: Colors.black,
                        icon: Icons.share,
                        iconColor: Colors.white,
                        iconSize: 20,
                        height: 35,
                        width: 35,
                        OnPressed: () async {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) =>
                                  new CustomLoader().buildLoader(context));
                          final link = await DynamicLinkService(context)
                              .createPostShareLink(widget.dataModel.id);
                          Navigator.of(context).pop();
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          {
                            await Share.share(link,
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
