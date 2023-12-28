import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ChangeNameLogic extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> changeName(String newName, BuildContext context) async {
    try {
      isLoading = true;
      update();

      // Fetch user document
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);

      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        dynamic lastChangeTimestamp = userSnapshot['lastNameChangeTimestamp'];

        DateTime currentTimestamp = DateTime.now();

        if (lastChangeTimestamp == null ||
            currentTimestamp.difference(lastChangeTimestamp.toDate()).inDays >=
                30) {
          await userDocRef.set(
            {
              'name': newName,
              'lastNameChangeTimestamp': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true), // Merge with existing data
          );

          isLoading = false;
          update();
        } else {
          isLoading = false;
          update();
          showError(context);
          print('You can only change your name once every 30 days.');
        }
      } else {
        // If the user document doesn't exist, create it
        await userDocRef.set(
          {
            'name': newName,
            'lastNameChangeTimestamp': FieldValue.serverTimestamp(),
          },
        );

        isLoading = false;
        update();
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Error changing name: $e');
    }
  }

  showError(BuildContext context) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'Oops...',
      text: 'You can only change your name once every 30 days.',
      loopAnimation: true,
      borderRadius: 5,
      barrierDismissible: false,
      lottieAsset: 'assets/lottie/error.json',
      onConfirmBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}
