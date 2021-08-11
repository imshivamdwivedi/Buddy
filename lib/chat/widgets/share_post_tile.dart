import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShareTile extends StatelessWidget {
  const ShareTile({
    Key? key,
    required this.model,
    required this.sendByMe,
  }) : super(key: key);

  final ActivityModel model;
  final sendByMe;

  @override
  Widget build(BuildContext context) {
    final _corners = 15.0;
    return Container(
      margin: EdgeInsets.all(4),
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
        color: kPrimaryColor,
      ),
      height: MediaQuery.of(context).size.height * 0.14,
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
                        child: model.img == ''
                            ? NamedProfileAvatar().profileAvatar(
                                model.title.substring(0, 1), 80.0)
                            : CachedNetworkImage(
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                                imageUrl: model.img,
                                placeholder: (context, url) {
                                  return Center(
                                      child: new SpinKitWave(
                                    type: SpinKitWaveType.start,
                                    size: 20,
                                    color: Colors.black87,
                                  ));
                                },
                                errorWidget: (context, url, error) =>
                                    NamedProfileAvatar().profileAvatar(
                                        model.title.substring(0, 1), 80.0),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
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
    );
  }
}
