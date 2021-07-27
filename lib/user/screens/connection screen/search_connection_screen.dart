import 'package:buddy/constants.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/users_connections/connection_handler.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchConnectionScreen extends StatefulWidget {
  static const routeName = '/search-connection-screen';
  const SearchConnectionScreen({Key? key}) : super(key: key);

  @override
  _SearchConnectionScreenState createState() => _SearchConnectionScreenState();
}

class _SearchConnectionScreenState extends State<SearchConnectionScreen> {
  final _auth = FirebaseAuth.instance;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    final userData = Provider.of<HomeSearchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                focusColor: Colors.black87,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Buddy',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: userData.suggestedUsers[index],
                child: Consumer<HomeSearchHelper>(
                  builder: (_, user, child) => userCard(user.userModel, user),
                ),
              ),
              itemCount: userData.suggestedUsers.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget userCard(UserModel userModel, HomeSearchHelper user) {
    return Card(
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
              // CircleAvatar(
              //   radius: MediaQuery.of(context).size.height * 0.04,
              // child: userModel.userImg == ''
              //     ? NamedProfileAvatar().profileAvatar(
              //         userModel.firstName.substring(0, 1),
              //       )
              //     : Image.network(userModel.userImg),
              // )
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: userModel.userImg == ''
                      ? NamedProfileAvatar().profileAvatar(
                          userModel.firstName.substring(0, 1),
                        )
                      : Image.network(
                          userModel.userImg,
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
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
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        userModel.firstName + " " + userModel.lastName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
                      Text(userModel.collegeName),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSkillChip('Chess'),
                      SizedBox(
                        width: 10,
                      ),
                      _buildChip("4.5"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      roundButton(
                          'Request',
                          user,
                          Provider.of<UserProvider>(context, listen: false)
                              .getUserName)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget roundButton(String text, HomeSearchHelper user, String userName) {
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
      onPressed: user.isFriend
          ? null
          : () {
              //---(Creating Request)----//
              ConnectionHandler().createRequest(_auth.currentUser!.uid,
                  user.userModel.id, context, userName, user);
            },
    );
  }
}
