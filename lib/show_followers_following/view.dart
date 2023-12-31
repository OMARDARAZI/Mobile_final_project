import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/scaned_profile/view.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'logic.dart';

class ShowFollowersFollowingPage extends StatelessWidget {
  ShowFollowersFollowingPage({Key? key, required this.coll}) : super(key: key);

  final logic = Get.put(ShowFollowersFollowingLogic());
  String coll;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(coll.toString(), style: const TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: firestore
              .collection('users')
              .doc(auth.currentUser!.uid)
              .collection(coll)
              .snapshots(),
          builder: (context, Fsnapshot) {
            if (Fsnapshot.hasData) {
              if (Fsnapshot.data!.docs.length > 0) {
                return ListView.builder(
                  itemCount: Fsnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: firestore
                            .collection('users')
                            .doc(Fsnapshot.data!.docs[index].id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              onTap: () {
                                Get.to(() => ScanedProfilePage(
                                    id: Fsnapshot.data!.docs[index].id));
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(snapshot.data!.get('pfp')),
                                radius: 20,
                              ),
                              title: Text(snapshot.data!.get('name')),

                            );
                          } else {
                            return const Center(
                              child: Loading(),
                            );
                          }
                        });
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No $coll ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                );
              }
            } else {
              return const Loading();
            }
          }),
    );
  }
}
