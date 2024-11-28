import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

class  UserModel{
  final CollectionReference sellPostCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> insertUser(localUser user) async {

    DocumentReference docRef = await sellPostCollection.add(user.toMap());
    user.reference = docRef;

  }
  Future<localUser?> getUserById(String id) async {
    try {
      // Query Firestore for a document where the `id` field matches
      QuerySnapshot snapshot = await sellPostCollection.where('id', isEqualTo: id).get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        localUser user = localUser.fromMap(data);
        user.reference = doc.reference;
        return user;
      } else {
        print('No user found with id: $id');
        return null;
      }
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }





}