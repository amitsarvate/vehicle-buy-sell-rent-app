import 'package:cloud_firestore/cloud_firestore.dart';

class localUser{
  String? name;
  String ? lastName;
  String ? phoneNumber;
  String?email;
  String? id;
  DocumentReference? reference;

  localUser(this.name,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.id,
      this.reference
      );
  localUser.fromMap(Map<String,dynamic> map,{this.reference}){
    this.id = map['id'];
    this.name = map['name'];
    this.lastName = map['lastName'];
    this.email = map['email'];
    this.phoneNumber = map['phoneNumber'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'lastName': this.name,
      'phoneNumber': this.phoneNumber,
      'email': this.email,

    };
  }
}