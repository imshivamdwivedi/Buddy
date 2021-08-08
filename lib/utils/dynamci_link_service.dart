import 'package:buddy/chat/screens/event_detail_screen.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  final BuildContext context;

  DynamicLinkService(this.context);

  Future handleDynamicLinks() async {
    //---( Getting Dynamic Link Data )---//
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLinkData(data, context);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? data) async {
        _handleDeepLinkData(data, context);
      },
      onError: (OnLinkErrorException e) async {
        print('Dynamic Link Error --> ${e.message}');
      },
    );
  }

  Future<String> createPostShareLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buddies.page.link',
      link: Uri.parse('https://www.buddies.in/post?id=$id'),
      androidParameters: AndroidParameters(packageName: 'com.example.buddy'),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }

  void _handleDeepLinkData(PendingDynamicLinkData? data, BuildContext context) {
    final Uri? uri = data?.link;
    if (uri != null) {
      print('  DeepLink  -->  $uri');
      var isPostShare = uri.pathSegments.contains('post');
      if (isPostShare) {
        var id = uri.queryParameters['id'];
        if (id != null) {
          final _tempDB =
              FirebaseDatabase.instance.reference().child('Activity');
          _tempDB.child(id).once().then((DataSnapshot snapshot) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                  activityModel: ActivityModel.fromMap(snapshot.value)),
            ));
          });
        }
      }
    }
  }
}
