import 'dart:ui';

import 'package:buddy/constants.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          "Hydra",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: size.height * 0.15,
                left: size.width * 0.1,
                right: size.width * 0.1),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Members",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    _buildChip('16.8 K'),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.1,
                ),
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
                      child: Image.asset(
                        'assets/images/elon.jpg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  width: size.width * 0.1,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 36,
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
            ),
            child: Row(
              children: [
                Text("Managers"),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.verified_user_sharp)
              ],
            ),
          )
        ],
      ),
      // body: Scrollbar(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         Stack(children: <Widget>[
      //           Image.asset(
      //             'assets/images/elon.jpg',
      //             fit: BoxFit.cover,
      //             height: size.height * 0.4,
      //             width: double.infinity,
      //           ),
      //           Container(
      //               margin: EdgeInsets.only(top: 200, right: 50, left: 10),
      //               child: Text(
      //                 "Space X",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 24,
      //                     fontWeight: FontWeight.bold),
      //               )),
      //         ]),
      //         Card(
      //           color: kPrimaryLightColor,
      //           margin: EdgeInsets.symmetric(
      //             vertical: 5,
      //           ),
      //           child: Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   Padding(
      //                     padding: EdgeInsets.symmetric(horizontal: 5),
      //                     child: Text(
      //                       "Description",
      //                       style: TextStyle(
      //                           color: Colors.black,
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               Row(
      //                 children: [
      //                   Flexible(
      //                     child: Padding(
      //                       padding: EdgeInsets.symmetric(
      //                           vertical: 5, horizontal: 5),
      //                       child: Text(
      //                         "Instagram - https://www.instagram.com/kietecell/ jbhcbjhbvhrvrtjvnrkjvnrkjnfkjrnvkjrvnkrjvnrkjnvkjrnvkjrnvkjrnvkjrnkjvnr vrvjrvnkrjvnvrjn",
      //                         style: TextStyle(
      //                           color: Colors.black,
      //                         ),
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //         Card(
      //           margin: EdgeInsets.only(
      //             top: 5,
      //           ),
      //           color: kPrimaryLightColor,
      //           child: Column(
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: 5),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       "6 Particpant",
      //                       style: TextStyle(color: Colors.brown),
      //                     ),
      //                     IconButton(
      //                         onPressed: () {},
      //                         icon: Icon(
      //                           Icons.search,
      //                           color: Colors.black,
      //                         ))
      //                   ],
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parneet"),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parneet"),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parneet"),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parneet"),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parneet"),
      //               ),
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 20,
      //                   backgroundImage: NetworkImage(
      //                       "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //                 ),
      //                 title: Text("Parnnet"),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
