import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../constants.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    var userModel;
    return Card(
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
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      // child: userModel.userImg == ''
                      //     ? NamedProfileAvatar().profileAvatar(
                      //         userModel.firstName.substring(0, 1), 80.0)
                      child: CachedNetworkImage(
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/buddy-ae267.appspot.com/o/UserImages%2F0Etid34298grAwMLOCmAX1FTwt72%2Fimage_picker2255930506045845358.jpg?alt=media&token=fc44be39-bfe8-4a41-9b69-6be343b0432f",
                        placeholder: (context, url) {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                                child: new SpinKitWave(
                              type: SpinKitWaveType.start,
                              size: 20,
                              color: Colors.black87,
                            )),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            NamedProfileAvatar().profileAvatar('E', 80.0),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Shivam Dwivedi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('KIET'),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSkillChip('Fri,Jul 20,2021'),
                          SizedBox(
                            width: 10,
                          ),
                          _buildChip('4:50 pm', Icons.lock_clock),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    String label,
    IconData iconData,
  ) {
    return Container(
      width: label.length * 14,
      height: 20,
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 1.0)),
            InkWell(
              child: Icon(
                iconData,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(
    String label,
  ) {
    return Container(
      width: label.length * 8,
      height: 20,
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
