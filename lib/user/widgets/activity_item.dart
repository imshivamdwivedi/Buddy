import 'dart:math' as math;

import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ActivityItem extends StatefulWidget {
  final ActivityModel dataModel;

  ActivityItem({required this.dataModel});

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
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
    return Container(
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
                          child: CachedNetworkImage(
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/buddy-ae267.appspot.com/o/UserImages%2F0Etid34298grAwMLOCmAX1FTwt72%2Fimage_picker2255930506045845358.jpg?alt=media&token=fc44be39-bfe8-4a41-9b69-6be343b0432f",
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
                                'E',
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      ),
                    ),
                    ProfileFloatingButton(
                      color: Colors.black,
                      icon: Icons.add,
                      iconColor: Colors.white,
                      iconSize: 20,
                      height: 35,
                      width: 35,
                    ),
                    ProfileFloatingButton(
                      color: Colors.black,
                      icon: Icons.share,
                      iconColor: Colors.white,
                      iconSize: 20,
                      height: 35,
                      width: 35,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
