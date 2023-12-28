import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EditBioLogic extends GetxController {

  bool isLoading=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateBio(String newBio,BuildContext context) async {
    try {
      isLoading=true;
      update();

      if (_auth.currentUser == null) {
        throw Exception("User not signed in");
      }
      String uid = _auth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).update({
        'bio': newBio,
      });

      print('Bio updated successfully');

      isLoading=false;
      update();
      Navigator.pop(context);
    } catch (error) {
      isLoading=false;
      update();
      print('Error updating bio: $error');
    }
  }
}
