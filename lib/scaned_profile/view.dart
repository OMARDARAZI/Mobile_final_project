import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/widgets/FollowBtn.dart';
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

import '../add_account/logic.dart';
import '../add_account/view.dart';
import '../edit_bio/view.dart';
import '../settings/view.dart';
import '../widgets/itemCard.dart';
import '../widgets/loading.dart';
import '../widgets/shimmer_effect.dart';
import 'logic.dart';

class ScanedProfilePage extends StatefulWidget {
  ScanedProfilePage({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<ScanedProfilePage> createState() => _ScanedProfilePageState();
}

class _ScanedProfilePageState extends State<ScanedProfilePage> {
  final logic = Get.put(ScanedProfileLogic());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  final controller = FlipCardController();

  @override
  void initState() {
    logic.checkFollowStatus(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanedProfileLogic>(
      init: ScanedProfileLogic(),
      builder: (logic) {
        return StreamBuilder(
            stream: firestore.collection('users').doc(widget.id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.exists) {
                  return Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      title: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    backgroundColor: Theme
                        .of(context)
                        .backgroundColor,
                    body: ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.flipcard();
                              },
                              child: FlipCard(
                                rotateSide: RotateSide.left,
                                backWidget: Container(
                                  width: 48.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff7F4CA6),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StreamBuilder(
                                        stream: firestore
                                            .collection('users')
                                            .doc(widget.id)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var data = snapshot.data!
                                                .data(); // Get the document data as a map
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
                                            .doc(widget.id)
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
                                        'ID: ${widget.id}',
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
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: QrImageView(
                                          size: 30.w,
                                          data: widget.id,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StreamBuilder(
                                        stream: firestore
                                            .collection('users')
                                            .doc(widget.id)
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
                                        'ID: ${widget.id}',
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
                              height: 3.h,
                            ),
                            StreamBuilder(
                              stream: firestore
                                  .collection('users')
                                  .doc(widget.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: SizedBox(
                                          width:
                                          MediaQuery
                                              .sizeOf(context)
                                              .width *
                                              0.8,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data!.get('bio'),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return ShimmerContainer(
                                      width: 200, height: 30);
                                }
                              },
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    /**Followers*/
                                    StreamBuilder(
                                      stream: firestore
                                          .collection('users')
                                          .doc(widget.id)
                                          .collection('Followers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              Text(
                                                '${snapshot.data!.docs.length}',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Followers',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              )
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Followers',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    /**following*/
                                    StreamBuilder(
                                      stream: firestore
                                          .collection('users')
                                          .doc(widget.id)
                                          .collection('following')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              Text(
                                                '${snapshot.data!.docs.length}',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Following',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              )
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Followers',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    /**Followers*/
                                    StreamBuilder(
                                      stream: firestore
                                          .collection('users')
                                          .doc(widget.id)
                                          .collection('accounts')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: [
                                              Text(
                                                '${snapshot.data!.docs.length}',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Accounts',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                'Accounts',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2.5.h),


                            GestureDetector(
                              onTap: () async {
                                print(logic.followStatus);

                                  if (logic.followStatus == 'Follow') {
                                    logic.followTapped(snapshot.data!.id);
                                  } else if (logic.followStatus ==
                                      'Requested') {
                                    await logic
                                        .deleteRequest(snapshot.data!.id);
                                  }
                                  else if(logic.followStatus=='Following'){
                                    logic.unFollow(snapshot.data!.id);
                                  }

                                logic.checkFollowStatus(snapshot.data!.id);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(7)),
                                child: Center(
                                  child: Text(
                                    logic.followStatus,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.5.h),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                ),
                              ),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: StreamBuilder(
                                stream: firestore
                                    .collection('users')
                                    .doc(widget.id)
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
                                                  closeIconColor: Colors.white,
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
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      backgroundColor: Theme
                          .of(context)
                          .backgroundColor,
                      body: Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
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
                return const Scaffold(body: Center(child: Loading()));
              }
            });
      },
    );
  }

  Widget _buildButton({required IconData icon,
    required String text,
    required VoidCallback onTap,
    required BuildContext context}) {
    return Container(
      width: MediaQuery
          .sizeOf(context)
          .width * .8,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 8.0),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
