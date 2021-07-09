import 'package:buddy/user/models/item_model.dart';
import 'package:buddy/user/models/user_genre_provider.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../components/social_icons.dart';
import 'package:flutter/material.dart';

class UserGenre extends StatefulWidget {
  static const routeName = '/user-genre';

  @override
  _UserGenreState createState() => _UserGenreState();
}

class _UserGenreState extends State<UserGenre> {
  bool init = true;
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final _databaseReference =
      FirebaseDatabase.instance.reference().child('Items');
  final _userDatabase = FirebaseDatabase.instance.reference().child('Users');

  void _saveUserGenre(List<ItemModel> finalList) async {
    final _user = _auth.currentUser;
    final _refUser = _firebaseDatabase
        .reference()
        .child('Users')
        .child(_user!.uid)
        .child('userGenre');

    _refUser.set(null);

    for (int i = 0; i < finalList.length; i++) {
      _refUser.child(i.toString()).child('text').set(finalList[i].text);
    }

    Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      final _user = _auth.currentUser;
      _userDatabase
          .orderByChild('id')
          .equalTo(_user!.uid)
          .once()
          .then((DataSnapshot snapshot) {
        String name = snapshot.value[_user.uid]['firstName'].toString() +
            ' ' +
            snapshot.value[_user.uid]['lastName'].toString();
        print(name);
        Provider.of<UserGenreProvider>(context, listen: false).setName(name);
      });
      _databaseReference.once().then((DataSnapshot snapshot) {
        List<ItemModel> myList = [];
        List res = snapshot.value;
        for (var item in res) {
          myList.add(ItemModel(text: item['text']));
        }
        Provider.of<UserGenreProvider>(context, listen: false).addList(myList);
      });
      init = false;
    }
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
                    Consumer<UserGenreProvider>(
                      builder: (_, userGenre, ch) => Text(
                        userGenre.userName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Choose your Genre",
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
                    _saveUserGenre(
                        Provider.of<UserGenreProvider>(context, listen: false)
                            .onlySelected);
                  },
                  iconSrc: 'assets/icons/next.svg',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Consumer<UserGenreProvider>(
            builder: (_, userGenre, ch) => Flexible(
              child: userGenre.allGenre.isEmpty
                  ? CircularProgressIndicator.adaptive()
                  : GridView.builder(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      itemCount: userGenre.allGenre.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 5 / 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                        value: userGenre.allGenre[index],
                        child: Consumer<ItemModel>(
                          builder: (ctx, product, child) => InkWell(
                            onTap: () => product.toggleSelected(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: product.isSelected
                                    ? Colors.black87
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  product.text,
                                  style: TextStyle(
                                    color: product.isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
