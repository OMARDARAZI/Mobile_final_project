import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/scaned_profile/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../widgets/imageLoading.dart';
import 'logic.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logic = Get.put(HomeLogic());

  CardSwiperController cardController = CardSwiperController();

  late final String otherUserID;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: StreamBuilder(
          stream: logic.firestore
              .collection('users')
              .where('suggestAccount', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CardSwiper(
                onSwipe: (previousIndex, currentIndex, direction) {
                  return true;
                },
                controller: cardController,
                cardsCount: snapshot.data!.docs.length,
                numberOfCardsDisplayed: snapshot.data!.docs.length,
                isLoop: true,
                cardBuilder: (context, index, horizontalOffsetPercentage,
                    verticalOffsetPercentage) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ScanedProfilePage(
                            id: snapshot.data!.docs[index].id,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.sizeOf(context).width * .9,
                        height: MediaQuery.sizeOf(context).height * .55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.sizeOf(context).width * 2),
                                    child: MyImageWidget(
                                      hieght: 150,
                                      width: 150,
                                      imageUrl:
                                          snapshot.data!.docs[index].get('pfp'),
                                    ),
                                  ),
                                ),
                                snapshot.data!.docs[index].get('isOnline')
                                    ? const Positioned(
                                        top: 0,
                                        right: 90,
                                        child: Icon(
                                          Icons.circle,
                                          size: 35,
                                          color: Colors.green,
                                        ))
                                    : Container(),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              snapshot.data!.docs[index].get('name'),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data!.docs[index].get('bio'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ScanedProfilePage(
                                        id: snapshot.data!.docs[index].id,
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: const Center(
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
