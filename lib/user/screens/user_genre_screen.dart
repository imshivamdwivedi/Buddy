import 'package:buddy/constants.dart';
import 'package:buddy/user/models/category_class.dart';
import 'package:buddy/user/widgets/category_chips.dart';
import 'package:flutter/material.dart';

class UserGenreScreen extends StatefulWidget {
  const UserGenreScreen({Key? key}) : super(key: key);

  @override
  _UserGenreScreenState createState() => _UserGenreScreenState();
}

class _UserGenreScreenState extends State<UserGenreScreen> {
  List<Category> userCatgeoryList = [
    Category(name: "Flutter", count: 1),
    Category(name: 'Music', count: 2),
    Category(name: "Cricket", count: 3),
    Category(name: "Time", count: 3),
    Category(name: "History", count: 3),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.2),
          child: Column(
            children: [
              Center(
                child: Text("What you want to learn ?",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
              Container(
                height: size.height * 0.7,
                child: ListView.builder(
                  itemCount: userCatgeoryList.length,
                  itemBuilder: (context, index) {
                    String name = userCatgeoryList[index].name;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Chip(
                            labelPadding: EdgeInsets.all(2.0),
                            label: Text(
                              name,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            backgroundColor: kPrimaryLightColor,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
