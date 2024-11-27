import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

class  UserModel{
  final CollectionReference sellPostCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> insertUser(User user) async {

    DocumentReference docRef = await sellPostCollection.add(user.toMap());
    user.reference = docRef;

  }


}