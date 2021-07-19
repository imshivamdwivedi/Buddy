import 'package:buddy/components/searchbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  // @override
  // void initState() {
  //   print("INIT HERE  ============================= ");
  //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //     final _user = _auth.currentUser;
  //     final List<String> friendsId = [];
  //     final _friendsDB = FirebaseDatabase.instance
  //         .reference()
  //         .child('Friends')
  //         .child(_user!.uid);
  //     await _friendsDB.once().then((DataSnapshot snapshot) {
  //       if (snapshot.value != null) {
  //         Map map = snapshot.value;
  //         map.values.forEach((element) {
  //           friendsId.add(element['uid']);
  //         });
  //       }
  //     });
  //     final List<HomeSearchHelper> allUsersList = [];
  //     final _searchDB = FirebaseDatabase.instance.reference().child('Users');
  //     await _searchDB.once().then((DataSnapshot snapshot) {
  //       if (snapshot.value != null) {
  //         Map map = snapshot.value;
  //         map.values.forEach((element) {
  //           if (element['id'] != _user.uid) {
  //             final userM = UserModel.fromMap(element);
  //             final homeU = HomeSearchHelper(
  //                 userModel: userM,
  //                 isFriend: friendsId.contains(element['id']));
  //             allUsersList.add(homeU);
  //           }
  //         });
  //       }
  //     });
  //     Provider.of<HomeSearchProvider>(context, listen: false)
  //         .setAllUsers(allUsersList);
  //   });
  //   super.initState();
  // }

  // final List<UserModel> userList = [
  //   UserModel(
  //       firstName: 'Parneet',
  //       lastName: "Raghuvanshi",
  //       dob: '14/07/2021',
  //       email: 'hcdgcv@gmail.com',
  //       gender: 'male',
  //       collegeName: 'Kiet',
  //       id: 'bcdvc',
  //       profile: true),
  //   UserModel(
  //       firstName: 'Parneet',
  //       lastName: "Sharma",
  //       dob: '14/07/2021',
  //       email: 'hcdgcv@gmail.com',
  //       gender: 'male',
  //       collegeName: 'Kiet',
  //       id: 'bcdvc',
  //       profile: true),
  //   UserModel(
  //       firstName: 'Parneet',
  //       lastName: "Dwivedi",
  //       dob: '14/07/2021',
  //       email: 'hcdgcv@gmail.com',
  //       gender: 'male',
  //       collegeName: 'Kiet',
  //       id: 'bcdvc',
  //       profile: true),
  //   UserModel(
  //       firstName: 'Parneet',
  //       lastName: "Devgan",
  //       dob: '14/07/2021',
  //       email: 'hcdgcv@gmail.com',
  //       gender: 'male',
  //       collegeName: 'Kiet',
  //       id: 'bcdvc',
  //       profile: true),
  //   UserModel(
  //       firstName: 'Parneet',
  //       lastName: "Bieber",
  //       dob: '14/07/2021',
  //       email: 'hcdgcv@gmail.com',
  //       gender: 'male',
  //       collegeName: 'Kiet',
  //       id: 'bcdvc',
  //       profile: true),
  // ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userData = Provider.of<HomeSearchProvider>(context).suggestedUsers;
    final usermodel = userData[0].userModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: SearchBar(
          text: 'Search',
          val: false,
          controller: _searchController,
        ),
      ),
      // body: Container(
      //   height: MediaQuery.of(context).size.height * 0.8,
      //   child: FirebaseAnimatedList(
      //     query: _refAct,
      //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
      //         Animation<double> animation, int index) {
      //       Map data = snapshot.value;
      //       return ActivityItem(
      //         dataModel: ActivityModel.fromMap(data),
      //       );
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        child: userData.isEmpty
            ? CircularProgressIndicator()
            : UserCard(usermodel),
      ),
    );
  }

  Widget UserCard(UserModel userModel) {
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
              CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.06,
                backgroundImage: NetworkImage(
                    "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
              )
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
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                        width: 70,
                      ),
                      roundButton('Request')
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
}
