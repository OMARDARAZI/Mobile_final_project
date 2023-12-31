import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/scaned_profile/logic.dart';
import 'package:finale_proj/widgets/RequestsTiles.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'logic.dart';

class RequestsPage extends StatelessWidget {
  RequestsPage({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestsLogic>(
      init: RequestsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Follow Requests',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
          ),
          body: GetBuilder<ScanedProfileLogic>(
            init: ScanedProfileLogic(),
            builder: (logic) {
              return StreamBuilder(
                stream: firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .collection('requests')
                    .snapshots(),
                builder: (context, requestsSnapshot) {
                  if (requestsSnapshot.hasData) {
                    if (requestsSnapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: requestsSnapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: firestore
                                .collection('users')
                                .doc(requestsSnapshot.data!.docs[index].id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RequestsTiles(
                                  name: snapshot.data!.get('name'),
                                  imageUrl: snapshot.data!.get('pfp'),
                                  onButton1Pressed: () {
                                    logic.acceptRequest(
                                        requestsSnapshot.data!.docs[index].id);
                                    logic.deleteRequest(
                                        requestsSnapshot.data!.docs[index].id);
                                  },
                                  onButton2Pressed: () {
                                    logic.deleteRequest(
                                        requestsSnapshot.data!.docs[index].id);
                                  },
                                );
                              } else {
                                return Center(
                                  child: Loading(),
                                );
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Requests',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
