import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/widgets/comment_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatefulWidget {
  final CommentModel commentModel;

  CommentTile(this.commentModel);
  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                child: widget.commentModel.userImg == ''
                    ? NamedProfileAvatar().profileAvatar(
                        widget.commentModel.userName.substring(0, 1), 40.0)
                    : CachedNetworkImage(
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                        imageUrl: widget.commentModel.userImg,
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
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: kPrimaryLightColor,
                padding: EdgeInsets.all(8),
                child: Text(
                  widget.commentModel.comment,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
