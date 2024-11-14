import 'package:cloud_firestore/cloud_firestore.dart';

class SellPost{
  String ?model ;
  int ?year;
  int? price ;
  String? description;
  String? image;
  String? id;
  DocumentReference? reference;
  //String userId;
  SellPost(
      this.model,
      this.year,
      this.price,
      this.description,
      this.image,
      this.id,
      this.reference


      );
  SellPost.fromMap(Map<String,dynamic> map,{this.reference}){
    this.id = reference?.id;
    this.model = map['model'];
    this.year = map['year'];
    this.image = map['image'];
    this.price = map['price'];
    this.description = map['description'];



  }
  Map<String, dynamic> toMap(){
    return {

      'model' :this.model,
      'year':this.year,
      'description' :this.description,
      'price':this.price,
      'image':this.image,
    };

  }




}
