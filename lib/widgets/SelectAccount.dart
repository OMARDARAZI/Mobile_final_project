import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/widgets/itemCard.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_account/logic.dart';

void showCustomBottomSheet(BuildContext context) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GetBuilder<AddAccountLogic>(
          init: AddAccountLogic(),
          builder: (logic) {
            return Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: StreamBuilder(
                  stream: firestore.collection('accounts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return ItemCard(
                            onTap: () {
                              logic.selectItem(name: snapshot.data!.docs[index].get('Name'), image: snapshot.data!.docs[index].get('image'), context: context);
                            },
                            image: '${snapshot.data!.docs[index].get('image')}',
                            name: '${snapshot.data!.docs[index].get('Name')}',
                          );
                        },
                      );
                    } else {
                      return Loading();
                    }
                  }),
            );
          });
    },
  );
}
