import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/user/models/category_class.dart';
import 'package:buddy/user/models/user_genre_provider.dart';
import 'package:buddy/user/screens/genre_searchbar/search_screen.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/social_icons.dart';
import '../../constants.dart';

class UserGenre extends StatefulWidget {
  static const routeName = '/user-genre';

  @override
  _UserGenreState createState() => _UserGenreState();
}

class _UserGenreState extends State<UserGenre> {
  bool init = true;
  bool isNew = true;
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  final _databaseReference =
      FirebaseDatabase.instance.reference().child('Items');
  final _userDatabase = FirebaseDatabase.instance.reference().child('Users');

  void _saveUserGenre(List<Category> finalList) async {
    if (finalList.isEmpty) {
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Please choose a genre !',
        color: Colors.red,
      );
      return;
    }
    //H://---( Saving Data to user Profile )---//
    final _userName = Provider.of<UserGenreProvider>(context, listen: false)
        .userName
        .replaceAll(' ', '')
        .toLowerCase();
    String finVal = '';
    for (int i = 0; i < finalList.length; i++) {
      if (i == 0) {
        finVal += finalList[i].id;
      } else {
        finVal += splitCode + finalList[i].id;
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

    //H://---( Saving Searchable Tag )---//
    final _refUserTag = _firebaseDatabase
        .reference()
        .child('Users')
        .child(_user.uid)
        .child('searchTag');
    _refUserTag.set(null);
    await _refUserTag.set(_userName + splitCode + finVal);

    //---( Updating Firebase Database )---//
    finalList.forEach((element) async {
      if (!element.isNew) {
        //---( Updating Count )---//
        final _refUpdate = _firebaseDatabase.reference().child('Items');
        await _refUpdate
            .orderByChild('id')
            .equalTo(element.id)
            .once()
            .then((value) {
          Map map = value.value;
          map.values.forEach((element) async {
            final newGenre = Category.fromMap(element);
            newGenre.count += 1;
            await _refUpdate
                .child(newGenre.id.toString())
                .set(newGenre.toMap());
          });
        });
      } else {
        //---( Adding New Ones )---//
        final _refUpdate = _firebaseDatabase.reference().child('Items');
        await _refUpdate.child(element.id.toString()).set(element.toMap());
      }
    });

    if (isNew) {
      Navigator.pushReplacementNamed(context, UserDashBoard.routeName);
    } else {
      Navigator.of(context).pop();
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Genre Updated Successfully !',
        color: Colors.green,
      );
    }
  }

  void _fetchGenre(BuildContext context) async {
    final _user = _auth.currentUser;
    await _databaseReference.once().then((DataSnapshot snapshot) {
      List<Category> myList = [];
      Map map = snapshot.value;
      map.values.forEach((element) {
        myList.add(Category.fromMap(element));
      });
      Provider.of<UserGenreProvider>(context, listen: false).addList(myList);
    });
    await _userDatabase
        .orderByChild('id')
        .equalTo(_user!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      String userGenre = snapshot.value[_user.uid]['userGenre'];
      String name = snapshot.value[_user.uid]['firstName'].toString() +
          ' ' +
          snapshot.value[_user.uid]['lastName'].toString();
      Provider.of<UserGenreProvider>(context, listen: false).setName(name);
      Provider.of<UserGenreProvider>(context, listen: false)
          .addPreGenre(userGenre);
      if (snapshot.value[_user.uid]['userGenre'] != '') {
        isNew = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      _fetchGenre(context);
      init = false;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Browse Category',
        backgroundColor: Colors.black87,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SearchScreen.routeName).then((value) {
            if (value != null) {
              CustomSnackbar().showFloatingFlushbar(
                context: context,
                message: value.toString(),
                color: Colors.green,
              );
            }
          });
        },
      ),
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
              child: userGenre.topGenre.isEmpty
                  ? CircularProgressIndicator.adaptive()
                  : GridView.builder(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      itemCount: userGenre.topGenre.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 7 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                        value: userGenre.topGenre[index],
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
