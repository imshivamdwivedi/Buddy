import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/user_profile_other.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserConnectionViewScreen extends StatefulWidget {
  const UserConnectionViewScreen({Key? key}) : super(key: key);

  @override
  _UserConnectionViewScreenState createState() =>
      _UserConnectionViewScreenState();
}

class _UserConnectionViewScreenState extends State<UserConnectionViewScreen> {
  @override
  Widget build(BuildContext context) {
    final userConnections = Provider.of<ChatSearchProvider>(context).allFriends;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('Connections',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                )),
          ),
        ),
        userConnections.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(
                          color: kPrimaryColor,
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      child: userConnections[index].userImg ==
                                              ''
                                          ? NamedProfileAvatar().profileAvatar(
                                              userConnections[index]
                                                  .name
                                                  .substring(0, 1),
                                              80.0)
                                          : CachedNetworkImage(
                                              width: 80.0,
                                              height: 80.0,
                                              fit: BoxFit.cover,
                                              imageUrl: userConnections[index]
                                                  .userImg,
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
                                              errorWidget: (context, url,
                                                      error) =>
                                                  NamedProfileAvatar()
                                                      .profileAvatar(
                                                          userConnections[index]
                                                              .name
                                                              .substring(0, 1),
                                                          80.0),
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
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtherUserProfileScreen(
                                                      userId:
                                                          userConnections[index]
                                                              .uid,
                                                    ),
                                                  ));
                                            },
                                            child: Text(
                                              userConnections[index].name,
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
                                          Text(userConnections[index]
                                              .collegeName),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Row(
                                        children: [
                                          _buildChip("4.5"),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3),
                                          roundButton('Following')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    childCount: userConnections.length),
              )
            : SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Connections.png",
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Center(
                        child: Text(
                          'You have no Connection !',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
      ]),
    );
  }

  Widget roundButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    );
  }

  Widget _buildChip(
    String label,
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
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
