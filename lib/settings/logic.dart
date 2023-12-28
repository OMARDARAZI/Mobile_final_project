import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/login/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingsLogic extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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


  Logout() async {
    await auth.signOut();
    Get.offAll(()=>LoginPage(),transition: Transition.downToUp);
  }
}
