import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddAccountLogic extends GetxController {
  String selectedImage = '';
  String selectedName = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String hint = 'Link';


  editAccount({image, name}){
    selectedImage=image;
    selectedName=name;
    update();
  }
  selectItem({required name, required image, required BuildContext context}) {
    this.selectedImage = image;
    this.selectedName = name;
    print(selectedName);
    if (selectedName == 'Whatsapp' || selectedName == 'Telephone') {
      hint = 'Phone Number';
      update();
    } else if (selectedName == 'Instagram' || selectedName == 'TikTok') {
      hint = 'UserName';
      update();
    } else {
      hint = 'Link';
      update();
    }
    update();
    Navigator.pop(context);
  }

  addAccount(
      {required name,
      required link,
      required image,
      required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (context) => Loading(),
    );
    var data = {
      'image': image,
      'name': name,
      'link': selectedName == 'Whatsapp'
          ? 'https://wa.me/$link'
          : selectedName == 'Instagram'
              ? 'https://www.instagram.com/$link/'
              : selectedName == 'TikTok'
                  ? 'https://www.tiktok.com/@$link'
                  : selectedName == 'Telephone'
                      ? 'tel:$link'
                      : link
    };

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('accounts')
        .doc(name)
        .set(data);

    Navigator.pop(context);
    Navigator.pop(context);
  }
}
