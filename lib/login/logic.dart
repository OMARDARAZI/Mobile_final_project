import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../nav_bar/view.dart';

class LoginLogic extends GetxController {
  bool isLoading = false;
  bool isObscure = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  changeObscure() {
    isObscure = !isObscure;
    update();
  }

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      update();
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      update();
      Get.offAll(()=>NavBarPage());
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

      print("Error signing in: $error");
      return null;
    }
  }
}
