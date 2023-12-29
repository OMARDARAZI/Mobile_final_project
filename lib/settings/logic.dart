import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/login/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SettingsLogic extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final picker = ImagePicker();
  File? _image;
  String? _imageUrl;

  File? get image => _image;

  changeSuggestAccount(value) async {
    var data = {'suggestAccount': value};
    await firestore.collection('users').doc(auth.currentUser!.uid).update(data);
    update();
  }

  changeOnline(value) async {
    var data = {'isOnline': value};
    await firestore.collection('users').doc(auth.currentUser!.uid).update(data);
    update();
  }

  changePublic(value, context) async {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            ),
            Text("Warning"),
          ],
        ),
        content:
            const Text("Are you sure you want to change your account public?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              var data = {'isPublic': value};
              Navigator.of(context).pop();

              await firestore
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .update(data);
              update();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
      context: context,
    );
  }

  Logout() async {
    await auth.signOut();
    Get.offAll(() => LoginPage(), transition: Transition.downToUp);
  }

  Future<void> pickImageAndUpload(BuildContext context) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Uploading image..."),
          ],
        ),
      ),
    );

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = File(pickedFile.path);

        // Call a method to upload the image to Firebase Storage
        await _uploadImageToStorage();

        // Call a method to update Firestore with the image URL
        await _updateFirestore();
      }
    } finally {
      // Close the loading dialog
      Navigator.of(context).pop();
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (_image == null) {
      return;
    }

    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('pfps')
          .child(auth.currentUser!.uid)
          .child('pfp.jpg');

      // Upload the file to Firebase Storage
      await storageRef.putFile(_image!);

      // Get the download URL of the uploaded file
      final imageUrl = await storageRef.getDownloadURL();
      _imageUrl = imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      print('send to: $email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An Email was send to $email check you inbox'),
        ),
      );
    } catch (e) {
      // Handle password reset errors
      print('Error sending password reset email: $e');
      throw e;
    }
  }

  Future<void> _updateFirestore() async {
    if (_imageUrl == null) {
      return;
    }

    try {
      final userId = auth.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'pfp': _imageUrl,
      });

      print('Firestore updated successfully');
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }
}
