import 'package:finale_proj/scaned_profile/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../widgets/imageLoading.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final logic = Get.put(HomeLogic());

  CardSwiperController cardController= CardSwiperController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: StreamBuilder(
            stream: logic.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CardSwiper(
                  controller: cardController,
                  cardsCount: snapshot.data!.docs.length,
                  numberOfCardsDisplayed: snapshot.data!.docs.length,
                  isLoop: true,
                  cardBuilder: (context, index, horizontalOffsetPercentage,
                      verticalOffsetPercentage) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: 500,
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.sizeOf(context).width * 2),
                              child: Image.network(
                                  snapshot.data!.docs[index].get('pfp'),
                                  width:
                                      MediaQuery.sizeOf(context).width * .45),
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
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(7)),
                                    child: const Center(
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 120,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: const Center(
                                      child: Text(
                                    'Add friend',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
