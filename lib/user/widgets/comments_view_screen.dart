import 'dart:math' as math;

import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/widgets/comment_model.dart';
import 'package:buddy/user/widgets/comment_tile.dart';
import 'package:buddy/user/widgets/comments_provider.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CommentViewScreen extends StatefulWidget {
  final ActivityModel dataModel;

  const CommentViewScreen({required this.dataModel});

  @override
  _CommentViewScreenState createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  final TextEditingController _commentController = TextEditingController();
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.dataModel.id);

    super.initState();
  }

  void _addComment() async {
    if (_commentController.text == null) {
      return;
    }
    final uid = _auth.currentUser!.uid;
    final User = Provider.of<UserProvider>(context, listen: false);
    final post_id = widget.dataModel.id;

    final refEventComment =
        _firebaseDatabase.reference().child('Comments').child(post_id);
    final cid = refEventComment.push().key;

    final commentPayload = CommentModel(
        cid: cid,
        uid: User.getUserId,
        comment: _commentController.text,
        userImg: User.getUserImg,
        userName: User.getUserName);
    await refEventComment.child(cid).set(commentPayload.toMap());
    _commentController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final commentList = Provider.of<CommentProvider>(context).allComments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Transform.rotate(
            angle: -math.pi / 4,
            child: IconButton(
              onPressed: () {},
              color: Colors.black,
              icon: Icon(Icons.send),
            ),
          ),
        ],
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height - kToolbarHeight - 24,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: commentList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommentTile(commentList[index]),
                      ),
                    ),
                  ),
                  Container(
                    color: kPrimaryColor,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              child: Provider.of<UserProvider>(context)
                                          .getUserImg ==
                                      ''
                                  ? NamedProfileAvatar().profileAvatar(
                                      Provider.of<UserProvider>(context)
                                          .getUserName
                                          .substring(0, 1),
                                      40.0)
                                  : CachedNetworkImage(
                                      width: 40.0,
                                      height: 40.0,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          Provider.of<UserProvider>(context)
                                              .getUserImg,
                                      placeholder: (context, url) {
                                        return Center(
                                            child: new SpinKitWave(
                                          type: SpinKitWaveType.start,
                                          size: 20,
                                          color: Colors.black87,
                                        ));
                                      },
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: _commentController,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20.0),
                            hintText: 'Add Comment',
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: _addComment,
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
