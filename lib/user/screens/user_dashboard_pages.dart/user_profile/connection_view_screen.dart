import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserConnectionViewScreen extends StatefulWidget {
  const UserConnectionViewScreen({Key? key}) : super(key: key);

  @override
  _UserConnectionViewScreenState createState() =>
      _UserConnectionViewScreenState();
}

class _UserConnectionViewScreenState extends State<UserConnectionViewScreen> {






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(

        slivers:[
          SliverAppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.black,
            
            floating: false,
            pinned: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            flexibleSpace: FlexibleSpaceBar(

                centerTitle: true,
                title:
                    Text('Connections',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),

                ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(

              (context, index) =>  Container(

                margin: EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(

                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                        ),
                        title: Text("Parneet Raghuvanshi"),
                      ),
                    ),
                    roundButton("Following")
                  ],
                ),
              ),
              childCount: 20),
          )
        ]
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
      onPressed: (){
        
      },
    );
  }
}
