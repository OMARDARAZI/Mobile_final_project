import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ScanedProfileLogic extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool btnPressable = false;
  String followStatus = 'Follow';

  setFollowState({required String state}) {
    followStatus = state;
    update();
  }

  Future<String> checkFollowStatus(String userId) async {
    // Check if userId is in "Following" collection
    var followingDoc = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("Following")
        .doc(userId)
        .get();

    if (followingDoc.exists) {
      followStatus = 'Following';
      update();
      return 'Following';
    }

    // Check if userId is in "Requested" collection
    var requestedDoc = await firestore
        .collection('users')
        .doc(userId)
        .collection("requests")
        .doc(auth.currentUser!.uid)
        .get();

    if (requestedDoc.exists) {
      followStatus = 'Requested';
      btnPressable = true;
      followStatus = 'Requested';

      update();
      update();

      return 'Requested';
    }

    // Check if userId is in "Followers" collection
    // var followersDoc = await firestore
    //     .collection('users')
    //     .doc(auth.currentUser!.uid)
    //     .collection("Followers")
    //     .doc(userId)
    //     .get();
    //
    // if (followersDoc.exists) {
    //   followStatus='Following';
    //   btnPressable=true;
    //   update();
    //   return 'Following';
    // }

    // If not in any collection, return 'Follow'
    followStatus = 'Follow';
    btnPressable = true;
    update();

    return 'Follow';
  }

  Future<void> unFollow(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Following')
          .doc(documentId)
          .delete();

      FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .collection('Followers')
          .doc(auth.currentUser!.uid)
          .delete();

      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
      // Handle the error as needed
    }
  }

  Future<void> deleteRequest(String documentId) async {
    btnPressable = false;
    update();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('requests')
          .doc(documentId)
          .delete();

      print('Document deleted successfully');
      btnPressable = true;
      update();
    } catch (e) {
      btnPressable = true;
      update();
      print('Error deleting document: $e');
      // Handle the error as needed
    }
  }

  acceptRequest(String id) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection('Followers')
        .doc(id)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('Following')
        .doc(currentUser.uid)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
    });
    followStatus = 'Following';
    update();
    print("Successfully followed!");
  }

  void followTapped(String id) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      bool isPublic = userSnapshot.get('isPublic');

      if (isPublic) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .collection('Following')
            .doc(id)
            .set({
          'timestamp': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .collection('Followers')
            .doc(currentUser.uid)
            .set({
          'timestamp': FieldValue.serverTimestamp(),
        });
        followStatus = 'Following';
        update();
        print("Successfully followed!");
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .collection('requests')
            .doc(currentUser.uid)
            .set({
          'timestamp': FieldValue.serverTimestamp(),
        });
        followStatus = 'Requested';

        update();
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
