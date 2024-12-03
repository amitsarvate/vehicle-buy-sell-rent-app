import 'package:cloud_firestore/cloud_firestore.dart';
import 'SellPost.dart';

class SellPostModel{
  final CollectionReference sellPostCollection =
  FirebaseFirestore.instance.collection('sellPosts');

  Stream<List<SellPost>> getSellsPostStream() {
    return sellPostCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        SellPost sellPost = SellPost.fromMap(doc.data() as Map<String, dynamic>);
        sellPost.reference = doc.reference;
        return sellPost;
      }).toList();
    });
  }

  Future<void> insertSellPost(SellPost sellPost) async {
    try {

      DocumentReference docRef = await sellPostCollection.add(sellPost.toMap());

      await docRef.update({'reference': docRef.path});

      sellPost.reference = docRef;
    } catch (e) {
      print('Error inserting sell post: $e');
    }
  }

  Future<void> deleteSellPost(SellPost sellPost) async {
    if (sellPost.reference != null) {
      await sellPost.reference!.delete();
    } else {
      throw Exception("DocumentReference is null. Cannot delete grade.");
    }
  }




}