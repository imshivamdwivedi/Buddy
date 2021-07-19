import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class EventNotification extends StatefulWidget {
  const EventNotification({Key? key}) : super(key: key);

  @override
  _EventNotificationState createState() => _EventNotificationState();
}

class _EventNotificationState extends State<EventNotification> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
          color: kPrimaryLightColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                  ),
                  title: Text(
                    "kdcmdmcmdmcdmcdmccnhdbcbdcbdcmbdcmdc",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.black87,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
