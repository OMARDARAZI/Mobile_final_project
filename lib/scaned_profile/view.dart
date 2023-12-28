import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/itemCard.dart';
import '../widgets/loading.dart';
import 'logic.dart';

class ScanedProfilePage extends StatelessWidget {
  ScanedProfilePage({Key? key, required this.id}) : super(key: key);

  String id;
  final logic = Get.put(ScanedProfileLogic());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final controller = FlipCardController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanedProfileLogic>(
        init: ScanedProfileLogic(),
        builder: (logic) {
          return StreamBuilder(
              stream: firestore.collection('users').doc(id).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.exists) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        leading:
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),

                        title: Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor,
                      body: ListView(
                        children: [
                          Column(
                            children: [

                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.flipcard();
                                },
                                child: FlipCard(
                                  rotateSide: RotateSide.bottom,
                                  backWidget: Container(
                                    width: 48.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder(
                                          stream: firestore
                                              .collection('users')
                                              .doc(id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data = snapshot.data!.data();
                                              if (data != null &&
                                                  data.containsKey('pfp')) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    child: Image.network(
                                                      data['pfp'],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.w,
                                                    child: Image.asset(
                                                        'assets/images/user.png'),
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const Center(
                                                  child: Loading());
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder(
                                          stream: firestore
                                              .collection('users')
                                              .doc(id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data!.get('name')}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          'ID: ${auth.currentUser!.uid}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 7.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  frontWidget: Container(
                                    width: 48.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: QrImageView(
                                            size: 30.w,
                                            data: id,
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder(
                                          stream: firestore
                                              .collection('users')
                                              .doc(id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                '${snapshot.data!.get('name')}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          'ID: ${id}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 7.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  controller: controller,
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30))),
                                width: MediaQuery.of(context).size.width,
                                child: StreamBuilder(
                                  stream: firestore
                                      .collection('users')
                                      .doc(id)
                                      .collection('accounts')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return ItemCard(
                                            onTap: () async {
                                              String externalLink = snapshot
                                                  .data!.docs[index]
                                                  .get('link');
                                              try {
                                                await launchUrl(
                                                    Uri.parse(externalLink));
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    showCloseIcon: true,
                                                    closeIconColor:
                                                        Colors.white,
                                                    content: Text(
                                                        'Error launching URL'),
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ),
                                                );
                                              }
                                            },
                                            name: snapshot.data!.docs[index]
                                                .get('name'),
                                            image: snapshot.data!.docs[index]
                                                .get('image'),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Loading();
                                    }
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        backgroundColor: Theme.of(context).backgroundColor,
                        body: Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                  ),
                                  Image.asset(
                                    'assets/images/404.png',
                                    width: 300,
                                  ),
                                  Text(
                                    'User Not Found',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Scaffold(body: Center(child: Loading()));
                }
              });
        });
  }
}
