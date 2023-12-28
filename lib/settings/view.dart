import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/change_name/view.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import 'logic.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsLogic>(
      init: SettingsLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: StreamBuilder(
            stream: firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  snapshot.data!.get('pfp'),
                                  width: 70,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.get('name'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                                Text(
                                  snapshot.data!.get('email'),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 210,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Change Name'),
                                trailing: const Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  Get.to(()=>ChangeNamePage(),transition: Transition.rightToLeft);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: ListTile(
                                leading: const Icon(Iconsax.eye),
                                title: const Text('Suggest Account'),
                                trailing: Switch(
                                  value: snapshot.data!.get('suggestAccount'),
                                  onChanged: (value) {
                                    logic.changeSuggestAccount(value);
                                  },
                                ),
                                onTap: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: ListTile(
                                leading: const Icon(Iconsax.user_octagon),
                                title: const Text('Appear Online'),
                                trailing: Switch(
                                  value: snapshot.data!.get('isOnline'),
                                  onChanged: (value) {
                                    logic.changeOnline(value);
                                  },
                                ),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: ListTile(
                            trailing: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () {
                              logic.Logout();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                );
              }
              else{
                return Loading();
              }

            },
          ),
        );
      },
    );
  }
}
