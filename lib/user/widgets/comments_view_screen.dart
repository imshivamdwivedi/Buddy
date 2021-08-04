import 'package:buddy/user/widgets/comments_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentViewScreen extends StatefulWidget {
  final String postId;
  const CommentViewScreen(this.postId);

  @override
  _CommentViewScreenState createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  @override
  void initState() {
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final commentList = Provider.of<CommentProvider>(context).allComments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
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
                      child: Text(commentList[index].comment),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
