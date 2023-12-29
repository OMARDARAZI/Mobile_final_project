import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/nav_bar/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:bcrypt/bcrypt.dart';

import '../models/User.dart';

class RegisterLogic extends GetxController {
  bool isLoading = false;
  bool isObscure = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  changeObscure() {
    isObscure = !isObscure;
    update();
  }

  Future registerWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      isLoading = true;
      update();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user!.updateDisplayName(name);
      final String hashedPasssword = BCrypt.hashpw(password, BCrypt.gensalt());


      Users myUser = Users(
        name: name,
        email: email,
        password: hashedPasssword,
        pfp:
            'https://firebasestorage.googleapis.com/v0/b/contaction-44c5a.appspot.com/o/user.png?alt=media&token=ba0cab23-2a80-4bdb-b993-b12bc5d46022',
      );

      firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(myUser.toMap());

      isLoading = false;
      update();
      Get.offAll(() => NavBarPage());
      return result.user;
    } catch (error) {
      isLoading = false;
      update();

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text:
            'Sorry, ${error.toString().substring(error.toString().indexOf(']') + 1).trim()}',
      );

      return null;
    }
  }
}
