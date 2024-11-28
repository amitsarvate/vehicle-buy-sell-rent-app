import 'package:cloud_firestore/cloud_firestore.dart';

class SellPost{
  String ?make;
  String ?model;
  int ?year;
  int? price ;
  String? description;
  String? image;
  int? id;
  DocumentReference? reference;
  String ?userId;
  SellPost(
      this.make,
      this.model,
      this.year,
      this.price,
      this.description,
      this.image,
      this.id,
      this.reference,
      this.userId


      );
  SellPost.fromMap(Map<String,dynamic> map,{this.reference}){
    this.id = map['id'];
    this.make = map['make'];
    this.model = map['model'];
    this.year = map['year'];
    this.image = map['image'];
    this.price = map['price'];
    this.description = map['description'];
    this.userId = map['userId'];




  }
  Map<String, dynamic> toMap(){
    return {
      'make' :this.make,
      'model' :this.model,
      'year':this.year,
      'description' :this.description,
      'price':this.price,
      'image':this.image,
      'userId':this.userId,
    };

  }




}
