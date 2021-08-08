import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    //---( Getting Dynamic Link Data )---//
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLinkData(data);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? data) async {
        _handleDeepLinkData(data);
      },
      onError: (OnLinkErrorException e) async {
        print('Dynamic Link Error --> ${e.message}');
      },
    );
  }

  void _handleDeepLinkData(PendingDynamicLinkData? data) {
    final Uri? uri = data?.link;
    if (uri != null) {
      print('_handle Deep Link  |  DeepLink  $uri');
    }
  }
}
