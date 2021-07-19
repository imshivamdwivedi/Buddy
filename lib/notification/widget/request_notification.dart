import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class RequestNotification extends StatefulWidget {
  @override
  _RequestNotificationState createState() => _RequestNotificationState();
}

class _RequestNotificationState extends State<RequestNotification> {
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
                    "Shivam Dwivedi",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              roundButton("Confirm"),
              SizedBox(
                width: 10,
              ),
              roundButton("Delete"),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () {},
    );
  }
}
