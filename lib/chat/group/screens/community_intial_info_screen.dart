import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class CommunityIntialInfoCreateScreen extends StatefulWidget {
  static const routeName = '/Community-intial-info';
  const CommunityIntialInfoCreateScreen({Key? key}) : super(key: key);

  @override
  _CommunityIntialInfoCreateScreenState createState() =>
      _CommunityIntialInfoCreateScreenState();
}

class _CommunityIntialInfoCreateScreenState
    extends State<CommunityIntialInfoCreateScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "New Community",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.done,
              ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 30,
                  backgroundImage: AssetImage(
                    'assets/icons/camera.png',
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Provide a community name and optional community avatar",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              width: 85,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.grey,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage('assets/images/elon.jpg'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('${index}')
                                ],
                              ));
                        }),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
