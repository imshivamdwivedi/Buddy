import 'dart:ui';

import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class GroupDetailScreen extends StatefulWidget {
  static const routeName = "/group-detail";
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

enum FilterOptions {
  Favourites,
  All,
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  Widget _buildChip(
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        // runSpacing: 10,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _showOnlyFavourites = false;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          expandedHeight: 100.0,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    )),
              ],
            ),
            background: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Container(
                  child: Provider.of<UserProvider>(context).getUserImg == ''
                      ? NamedProfileAvatar().profileAvatar(
                          Provider.of<UserProvider>(context)
                              .getUserName
                              .substring(0, 1),
                          120.0)
                      : CachedNetworkImage(
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                          imageUrl:
                              Provider.of<UserProvider>(context).getUserImg,
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
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.format_list_bulleted, color: Colors.grey),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                height: size.height * 0.2,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Bio and Guidelines :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Flexible(
                      child: Text(
                        "bchjdsbchsdchbdsjhcbmdnsbchjs sdhbcshjdbchdsbcjhs nhbcsjhdbcnsdcbhsdcbm   jhdsbcjhdsbchjsdbcjhsbc bsdvcjhsdbcjhdbchdsbchsdbcbsdkhcbsdkjcbkdsjnc ncbhdsbckdsncjsdcknsdckjh",
                        maxLines: null,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //       (context, index) => ListTile(
        //             leading: CircleAvatar(
        //               radius: 20,
        //               backgroundImage: NetworkImage(
        //                   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
        //             ),
        //             title: Text("Parneet"),
        //           ),
        //       childCount: 10),
        // )

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            ///no.of items in the horizontal axis
            crossAxisCount: 4,
          ),

          ///Lazy building of list
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              /// if (index > n) return null;
              return index == 9
                  ? ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: kPrimaryLightColor,
                          child: Text(
                            "240 +",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  : ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                    );
            },

            /// Set childCount to limit no.of items
            childCount: 10,
          ),
        ),
      ]),
    );
  }
}
