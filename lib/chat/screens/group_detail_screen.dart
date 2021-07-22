import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  static const routeName = "/group-detail";
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

enum FilterOptions {
  Favourites,
  All,
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _showOnlyFavourites = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            color: kPrimaryColor,
            onSelected: (FilterOptions selectedvalue) {
              print(selectedvalue);
              print(_showOnlyFavourites);
              setState(() {
                if (selectedvalue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
              print(_showOnlyFavourites);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Leave Community'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Rate Community '),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: <Widget>[
                Image.asset(
                  'assets/images/elon.jpg',
                  fit: BoxFit.cover,
                  height: size.height * 0.4,
                  width: double.infinity,
                ),
                Container(
                    margin: EdgeInsets.only(top: 200, right: 50, left: 10),
                    child: Text(
                      "Space X",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
              ]),
              Card(
                color: kPrimaryLightColor,
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              "Instagram - https://www.instagram.com/kietecell/ jbhcbjhbvhrvrtjvnrkjvnrkjnfkjrnvkjrvnkrjvnrkjnvkjrnvkjrnvkjrnvkjrnkjvnr vrvjrvnkrjvnvrjn",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                color: kPrimaryLightColor,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "6 Particpant",
                            style: TextStyle(color: Colors.brown),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parneet"),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parneet"),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parneet"),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parneet"),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parneet"),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                      ),
                      title: Text("Parnnet"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
