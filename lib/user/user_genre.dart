import 'package:buddy/user/models/category_class.dart';
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

  void _saveUserGenre(List<Category> finalList) async {
    String finVal = '';

    for (int i = 0; i < finalList.length; i++) {
      if (i == 0) {
        finVal += finalList[i].name.toLowerCase();
      } else {
        finVal += '+' + finalList[i].name.toLowerCase();
      }
    }

    final _user = _auth.currentUser;
    final _refUser = _firebaseDatabase
        .reference()
        .child('Users')
        .child(_user!.uid)
        .child('userGenre');

    _refUser.set(null);

    await _refUser.set(finVal);

    //Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
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
        Provider.of<UserGenreProvider>(context, listen: false).setName(name);
      });
      _databaseReference.once().then((DataSnapshot snapshot) {
        List<Category> myList = [];
        List res = snapshot.value;
        for (var item in res) {
          myList.add(Category(name: item['name'], id: item['id']));
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
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      itemCount: userGenre.allGenre.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 7 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                        value: userGenre.allGenre[index],
                        child: Consumer<Category>(
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
                                child: FittedBox(
                                  child: Text(
                                    product.name,
                                    style: TextStyle(
                                      color: product.isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 14,
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
          ),
        ],
      ),
    );
  }
}
