import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:flutter/material.dart';

class SearchConnectionScreen extends StatefulWidget {
  static const routeName = '/search-connection-screen';
  const SearchConnectionScreen({Key? key}) : super(key: key);

  @override
  _SearchConnectionScreenState createState() => _SearchConnectionScreenState();
}

class _SearchConnectionScreenState extends State<SearchConnectionScreen> {
  final _searchController = TextEditingController();
  final List<UserModel> userList = [
    UserModel(
        firstName: 'Parneet',
        lastName: "Raghuvanshi",
        dob: '14/07/2021',
        email: 'hcdgcv@gmail.com',
        gender: 'male',
        collegeName: 'Kiet',
        id: 'bcdvc',
        profile: true),
    UserModel(
        firstName: 'Parneet',
        lastName: "Sharma",
        dob: '14/07/2021',
        email: 'hcdgcv@gmail.com',
        gender: 'male',
        collegeName: 'Kiet',
        id: 'bcdvc',
        profile: true),
    UserModel(
        firstName: 'Parneet',
        lastName: "Dwivedi",
        dob: '14/07/2021',
        email: 'hcdgcv@gmail.com',
        gender: 'male',
        collegeName: 'Kiet',
        id: 'bcdvc',
        profile: true),
    UserModel(
        firstName: 'Parneet',
        lastName: "Devgan",
        dob: '14/07/2021',
        email: 'hcdgcv@gmail.com',
        gender: 'male',
        collegeName: 'Kiet',
        id: 'bcdvc',
        profile: true),
    UserModel(
        firstName: 'Parneet',
        lastName: "Bieber",
        dob: '14/07/2021',
        email: 'hcdgcv@gmail.com',
        gender: 'male',
        collegeName: 'Kiet',
        id: 'bcdvc',
        profile: true),
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
      body: SingleChildScrollView(
        child: UserCard(userList[0]),
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
