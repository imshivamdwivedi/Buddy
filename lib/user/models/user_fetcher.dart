import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserFetcher {
  Future<UserModel> getUser(String uid) async {
    UserModel user = UserModel(profile: true);
    final _userDb = FirebaseDatabase.instance.reference().child('Users');
    await _userDb
        .orderByChild('id')
        .equalTo(uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          user = UserModel.fromMap(element);
        });
      }
    });
    return user;
  }
}
