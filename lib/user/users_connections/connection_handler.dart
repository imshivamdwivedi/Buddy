import 'package:buddy/user/users_connections/request_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ConnectionHandler {
  final _firebaseDatabase = FirebaseDatabase.instance;

  void createRequest(String userId, String targetId) {
    final _refReq =
        _firebaseDatabase.reference().child('Connection').child('Requests');
    final String _rid = _refReq.push().key;

    RequestModel requestModel = RequestModel(
      senId: userId,
      recId: targetId,
      createdAt: DateTime.now().toString(),
      status: 'pending',
      id: _rid,
    );

    _refReq.child(_rid).set(requestModel);
  }

  void acceptRequest(String rid) {
    //---( Fetch Request )---//
    final _refReq =
        _firebaseDatabase.reference().child('Connection').child('Requests');
    _refReq.once().then((DataSnapshot dataSnapshot) {
      Map myMap = dataSnapshot.value;
      myMap.values.forEach((element) {
        RequestModel requestModel = RequestModel.fromMap(myMap);
        final _rid = requestModel.id;

        //---( Accepting Friend and Deleting Request )---//
        final _refFriend =
            _firebaseDatabase.reference().child('Connection').child('Friends');
        final String _fid = _refFriend.push().key;
        requestModel.id = _fid;
        requestModel.status = 'accepted';
        _refFriend.child(_fid).set(requestModel);

        //---( Deleting Request )---//
        _refReq.child(_rid).set(null);
      });
    });
  }

  void declineRequest(String rid) {
    //---( Fetch Request )---//
    final _refReq =
        _firebaseDatabase.reference().child('Connection').child('Requests');
  }
}
