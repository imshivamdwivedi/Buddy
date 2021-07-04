import 'package:buddy/user/grid_dashboard.dart';

import '../components/social_icons.dart';
import 'package:flutter/material.dart';

class UserGenre extends StatelessWidget {
  static const routeName = '/user-genre';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Parneet Raghuvanshi",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SocalIcon(
                  onPressed: () {},
                  iconSrc: 'assets/icons/next.svg',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GridDashboard(),
        ],
      ),
    );
  }
}
