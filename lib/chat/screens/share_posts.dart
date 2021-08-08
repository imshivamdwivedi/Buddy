import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/models/dm_message_model.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/screens/share_post_model.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SharePost extends StatefulWidget {
  final postId;
  const SharePost({Key? key, required this.postId}) : super(key: key);

  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  final _auth = FirebaseAuth.instance;
  final List<SharePostModel> _shareList = [];

  @override
  void initState() {
    //---( Fecthing all the Communities Only )---//
    final _chatList =
        Provider.of<ChatListProvider>(context, listen: false).allChatList;
    setState(() {
      _chatList.forEach((element) {
        _shareList.add(
          SharePostModel(
            chid: element.chid,
            id: element.user,
            img: element.nameImg,
            name: element.name,
            isCom: element.user == _auth.currentUser!.uid,
            isSelected: false,
          ),
        );
      });
    });
    super.initState();
  }

  void _addToShareList(FriendsModel model) {
    bool isNew = true;
    _shareList.forEach((element) {
      if (element.id == model.uid) isNew = false;
    });

    if (isNew) {
      setState(() {
        _shareList.add(
          SharePostModel(
            chid: '',
            id: model.uid,
            img: model.userImg,
            name: model.name,
            isCom: false,
            isSelected: true,
          ),
        );
      });
    }
  }

  void _shareToAll() {
    //---( Finally Sharing to All )---//
    _shareList.forEach((element) {
      if (element.isSelected) {
        if (element.isCom) {
          //---( Sharing in Community )---//
          _addMessageToCommunity(element);
        } else {
          //---( Sharing in DM )---//
          if (element.chid == '') {
            //---( New Channel + First Message )---//
            _createNewDmChannel(element);
          } else {
            //---( Already Channel Exist + First Message )---//
            _addDMMessageToExisted(element);
          }
        }
      }
    });
    CustomSnackbar().showFloatingFlushbar(
      context: context,
      message: 'Event Shared Successfully !',
      color: Colors.green,
    );
  }

  void _addMessageToCommunity(SharePostModel element) async {
    final _msgDb = FirebaseDatabase.instance
        .reference()
        .child('Chats')
        .child(element.chid)
        .child('ChatRoom');
    final _msgKey = _msgDb.push().key;
    final _newMessage = NewDmMessage(
      msgId: _msgKey,
      senderId: _auth.currentUser!.uid,
      text: splitCode + 'sharepost=${widget.postId}',
      isRead: false,
      createdAt: DateTimeStamp().getDate(),
    );
    await _msgDb.child(_msgKey).set(_newMessage.toMap());
    Navigator.of(context).pop();
  }

  void _createNewDmChannel(SharePostModel element) async {
    //---( New Channel + First Message )---//
    final tempNameProvider = Provider.of<UserProvider>(context, listen: false);
    //---( Creating New Channel )---//
    final _channelDb = FirebaseDatabase.instance.reference().child('Chats');
    final _chid = _channelDb.push().key;
    final newChannel = DmChannel(
      chid: _chid,
      type: 'DM',
      users: _auth.currentUser!.uid + "+" + element.id,
    );
    await _channelDb.child(_chid).set(newChannel.toMap());

    //---( Creating Channel History )---//
    final _chRecord = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(_auth.currentUser!.uid)
        .child(_chid);
    final _channel = ChatListModel(
      chid: _chid,
      name: element.name,
      nameImg: element.img,
      user: element.id,
      msgPen: 0,
      lastMsg: '',
    );
    await _chRecord.set(_channel.toMap());

    final _chRecord1 = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(element.id)
        .child(_chid);
    final _channel1 = ChatListModel(
      chid: _chid,
      name: tempNameProvider.getUserName,
      nameImg: tempNameProvider.getUserImg,
      user: _auth.currentUser!.uid,
      msgPen: 0,
      lastMsg: '',
    );
    await _chRecord1.set(_channel1.toMap());
    //---( Channel Created Sending Message )---//
    element.chid = _chid;
    _addDMMessageToExisted(element);
  }

  void _addDMMessageToExisted(SharePostModel element) async {
    //---( Already Channel Exist + First Message )---//
    final _msgDb = FirebaseDatabase.instance
        .reference()
        .child('Chats')
        .child(element.chid)
        .child('ChatRoom');
    final _msgKey = _msgDb.push().key;
    final _newMessage = NewDmMessage(
      msgId: _msgKey,
      senderId: _auth.currentUser!.uid,
      text: splitCode + 'sharepost=${widget.postId}',
      isRead: false,
      createdAt: DateTimeStamp().getDate(),
    );
    await _msgDb.child(_msgKey).set(_newMessage.toMap());
    final _chHisUpdate =
        FirebaseDatabase.instance.reference().child('Channels');
    _chHisUpdate
        .child(element.id)
        .child(element.chid)
        .once()
        .then((DataSnapshot snapshot) async {
      await _chHisUpdate
          .child(element.id)
          .child(element.chid)
          .child('msgPen')
          .set(snapshot.value['msgPen'] + 1);
    });
    await _chHisUpdate
        .child(element.id)
        .child(element.chid)
        .child('lastMsg')
        .set('See Attachment !');
    await _chHisUpdate
        .child(_auth.currentUser!.uid)
        .child(element.chid)
        .child('lastMsg')
        .set('See Attachment !');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              _shareToAll();
            },
            child: Text("Send"),
          ),
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Container(
          height: size.height - kToolbarHeight,
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TypeAheadField<FriendsModel>(
                debounceDuration: Duration(microseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    focusColor: Colors.black87,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search User Name',
                  ),
                ),
                suggestionsCallback: UserAPI.getUserSuggestion,
                itemBuilder: (context, FriendsModel? suggestions) {
                  final friend = suggestions!;
                  return ListTile(
                    onTap: () {
                      _addToShareList(friend);
                    },
                    title: Text(friend.name),
                  );
                },
                noItemsFoundBuilder: (context) => Container(
                  height: 80,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No User found",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                onSuggestionSelected: (FriendsModel? suggestions) {
                  final friend = suggestions;

                  Text(friend!.name);
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: _shareList.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/nonewnot.png",
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'No Messages Yet !',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 600,
                        child: ListView.builder(
                          itemCount: _shareList.length,
                          itemBuilder: (context, index) {
                            final _shareTile = _shareList[index];
                            return Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: ListTile(
                                tileColor: kPrimaryColor,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    child: _shareTile.img == ''
                                        ? NamedProfileAvatar().profileAvatar(
                                            _shareTile.name.substring(0, 1),
                                            40.0)
                                        : Image.network(
                                            _shareTile.img,
                                            height: 40.0,
                                            width: 40.0,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  _shareTile.name,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                trailing: Checkbox(
                                  value: _shareTile.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      _shareList[index].isSelected =
                                          !_shareList[index].isSelected;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}
