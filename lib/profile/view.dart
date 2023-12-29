import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/add_account/logic.dart';
import 'package:finale_proj/add_account/view.dart';
import 'package:finale_proj/edit_bio/view.dart';
import 'package:finale_proj/requests/view.dart';
import 'package:finale_proj/settings/view.dart';
import 'package:finale_proj/widgets/imageLoading.dart';
import 'package:finale_proj/widgets/itemCard.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:finale_proj/widgets/shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'logic.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final controller = FlipCardController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileLogic>(
      init: ProfileLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: Tooltip(
              message: 'Follow Requests',
              child: Stack(
                children: [
                  Center(
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => RequestsPage(),
                            transition: Transition.rightToLeft);
                      },
                      icon: const Icon(
                        Iconsax.user_add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: firestore
                          .collection('users')
                          .doc(auth.currentUser!.uid)
                          .collection('requests')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.length > 0) {
                          return Positioned(
                            right: 5,
                            top: 5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                '${snapshot.data!.docs.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
            actions: [
              Tooltip(
                message: 'Settings',
                child: IconButton(
                    onPressed: () {
                      Get.to(() => SettingsPage(),
                          transition: Transition.rightToLeft,
                          curve: Curves.easeInBack);
                    },
                    icon: const Icon(
                      Iconsax.setting,
                      color: Colors.black,
                    )),
              ),
            ],
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
                                  .doc(auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!
                                      .data();
                                  if (data != null && data.containsKey('pfp')) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 30.w,
                                        height: 30.w,
                                        child: MyImageWidget(
                                          width: 2,
                                          hieght: 2,
                                          imageUrl: data['pfp'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 30.w,
                                        height: 30.w,
                                        child: Image.asset(
                                            'assets/images/user.png'),
                                      ),
                                    );
                                  }
                                } else {
                                  return const Center(child: Loading());
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                              stream: firestore
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
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
                                data: auth.currentUser!.uid,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder(
                              stream: firestore
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
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
                      controller: controller,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  StreamBuilder(
                    stream: firestore
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                    () => EditBioPage(
                                          bio: snapshot.data!.get('bio'),
                                        ),
                                    transition: Transition.rightToLeft);
                              },
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data!.get('bio'),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Iconsax.edit,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return ShimmerContainer(width: 200, height: 30);
                      }
                    },
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /**Followers*/
                          StreamBuilder(
                            stream: firestore
                                .collection('users')
                                .doc(auth.currentUser!.uid)
                                .collection('Followers')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        '${snapshot.data!.docs.length}',
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      '0',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
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
                                .doc(auth.currentUser!.uid)
                                .collection('Following')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    Text(
                                      '${snapshot.data!.docs.length}',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
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
                                .doc(auth.currentUser!.uid)
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Accounts',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Accounts',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
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
                  SizedBox(height: 5.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AddAccountPage());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ADD'),
                                Icon(Iconsax.add_circle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: StreamBuilder(
                      stream: firestore
                          .collection('users')
                          .doc(auth.currentUser!.uid)
                          .collection('accounts')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                return ItemCard(
                                  onLongPress: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          color: Colors.transparent,
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200]
                                                    ?.withOpacity(0.7),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GetBuilder<AddAccountLogic>(
                                                      init: AddAccountLogic(),
                                                      builder: (logic) {
                                                        return _buildButton(
                                                          context: context,
                                                          icon: Icons.edit,
                                                          text: 'Edit',
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);

                                                            logic.editAccount(
                                                              image: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get('image'),
                                                              name: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .get('name'),
                                                            );

                                                            Get.to(() =>
                                                                AddAccountPage());
                                                          },
                                                        );
                                                      }),
                                                  const SizedBox(height: 16.0),
                                                  _buildButton(
                                                    context: context,
                                                    icon: Icons.delete,
                                                    text: 'Delete',
                                                    onTap: () async {
                                                      DocumentSnapshot
                                                          documentToDelete =
                                                          snapshot.data!
                                                              .docs[index];
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(auth
                                                              .currentUser!.uid)
                                                          .collection(
                                                              'accounts')
                                                          .doc(documentToDelete
                                                              .id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onTap: () async {
                                    String externalLink =
                                        snapshot.data!.docs[index].get('link');
                                    try {
                                      await launchUrl(Uri.parse(externalLink));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          showCloseIcon: true,
                                          closeIconColor: Colors.white,
                                          content: Text('Error launching URL'),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  name: snapshot.data!.docs[index].get('name'),
                                  image:
                                      snapshot.data!.docs[index].get('image'),
                                );
                              },
                            );
                          } else {
                            return Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 70.h,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text('No Accounts Found!',style: TextStyle(fontSize: 20.sp),),

                                  Opacity(
                                    opacity: .5,
                                    child:
                                        Image.asset('assets/images/noData.jpg'),
                                  ),
                                ],
                              ),
                            );
                          }
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
      },
    );
  }

  Widget _buildButton(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      required BuildContext context}) {
    return Container(
      width: MediaQuery.sizeOf(context).width * .8,
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
