import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  String name;
  String email;
  String password;
  String? pfp;

  Users(
      {required this.name,
      required this.email,
      required this.password,
      this.pfp});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'pfp': pfp,
      'bio':'',
      'isPublic':true,
      'isOnline': true,
      'suggestAccount': true,
      'lastNameChangeTimestamp': FieldValue.serverTimestamp(),
      'Id':FirebaseAuth.instance.currentUser!.uid,
    };
  }
}
