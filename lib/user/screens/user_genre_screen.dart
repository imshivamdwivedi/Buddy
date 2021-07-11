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
    Category(name: "Tech", categoriesList: [
      'backend',
      'Frontend',
      'Android',
      'LLD',
      'HLD',
      'Competitive Programming'
    ]),
    Category(name: 'Music', categoriesList: ['Guitar', 'Ukulele', 'Drum']),
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
                        ListTile(
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        CatogoryChips(
                          categories: userCatgeoryList[index].categoriesList,
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
