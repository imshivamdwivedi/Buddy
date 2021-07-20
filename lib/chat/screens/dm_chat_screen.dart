import 'package:buddy/chat/widgets/chat_message_widget.dart';
import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class DmChatScreen extends StatefulWidget {
  static const routeName = '/dm-chat-screen';
  @override
  _DmChatScreenState createState() => _DmChatScreenState();
}

class _DmChatScreenState extends State<DmChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        foregroundColor: Colors.black87,
        backgroundColor: kPrimaryColor,
        title: Text(
          'Hello There !',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              MessageTile(
                message: "Congratulations, new leaders!",
                sendByMe: true,
              ),
              MessageTile(
                message: 'Hello There !',
                sendByMe: false,
              ),
              MessageTile(
                message: 'Hello There !',
                sendByMe: false,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: kPrimaryLightColor,
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: null,
                        //style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('msg sent ============== ');
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // gradient: LinearGradient(
                                //     colors: [
                                //       const Color(0x36FFFFFF),
                                //       const Color(0x0FFFFFFF)
                                //     ],
                                //     begin: FractionalOffset.topLeft,
                                //     end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/images/google.png",
                              height: 25,
                              width: 25,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
