import 'package:buddy/main.dart';
import 'package:buddy/user/item_model.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../components/social_icons.dart';
import 'package:flutter/material.dart';

class UserGenre extends StatefulWidget {
  static const routeName = '/user-genre';

  @override
  _UserGenreState createState() => _UserGenreState();
}

class _UserGenreState extends State<UserGenre> {
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final _databaseReference =
      FirebaseDatabase.instance.reference().child('Items');

  List<ItemModel> myList = [];

  void getList() async {
    await _databaseReference.once().then((DataSnapshot snapshot) {
      List res = snapshot.value;
      print(snapshot.value);
      for (var item in res) {
        myList.add(ItemModel(text: item['text']));
      }
    });
  }

  void _togglePress(String title) {
    setState(() {
      print('tapped');
      final _toggle =
          myList.firstWhere((element) => element.text == title).isSelected;
      myList.firstWhere((element) => element.text == title).isSelected =
          !_toggle;
    });
  }

  void _saveUserGenre(BuildContext context) async {
    Map<int, String> genreList = {};
    int i = 0;
    myList.forEach((element) {
      if (element.isSelected) {
        genreList.addAll({i: element.text});
        i++;
      }
    });
    Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
    final _user = _auth.currentUser;
    final _refUser =
        _firebaseDatabase.reference().child('Users').child(_user!.uid);

    await _refUser.once().then((DataSnapshot snapshot) {
      UserModel prevModel = UserModel.fromJson(snapshot);
      prevModel.genre = genreList;
      _refUser.set(prevModel.toJson());
    });

    Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

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
                  onPressed: () {
                    _saveUserGenre(context);
                  },
                  iconSrc: 'assets/icons/next.svg',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Flexible(
            child: GridView.count(
                childAspectRatio: 5 / 2,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: myList.map((data) {
                  return InkWell(
                    onTap: () => _togglePress(data.text),
                    child: Container(
                      decoration: BoxDecoration(
                        color: data.isSelected ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          data.text,
                          style: TextStyle(
                            color:
                                data.isSelected ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }
}
