import 'package:finale_proj/widgets/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import '../widgets/SelectAccount.dart';
import 'logic.dart';

class AddAccountPage extends StatelessWidget {
  AddAccountPage({Key? key}) : super(key: key);

  TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAccountLogic>(
      init: AddAccountLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Iconsax.arrow_left_2,
                color: Colors.black,
              ),
            ),
            title: Text(
              'Add Account',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
            child: ListView(
              physics: RangeMaintainingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                    ),
                    GestureDetector(
                      onTap: () {
                        showCustomBottomSheet(
                            context); // Call the method to show the bottom sheet
                      },
                      child: Container(
                        width: 25.h,
                        height: 25.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: logic.selectedImage == ''
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ADD',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Iconsax.add_circle,
                                    size: 30,
                                  )
                                ],
                              )
                            : ItemCard(
                                onTap: () {
                                  showCustomBottomSheet(context);
                                },
                                image: logic.selectedImage,
                                name: logic.selectedName),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: linkController,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(
                                  Iconsax.link,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: logic.hint,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        logic.addAccount(
                            name: logic.selectedName,
                            link: linkController.text.trim(),
                            image: logic.selectedImage,
                            context: context);
                      },
                      child: Container(
                        width: 50.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 9,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
