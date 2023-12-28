import 'package:finale_proj/qr_code_scanner/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'logic.dart';

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key}) : super(key: key);

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarLogic>(
      init: NavBarLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,
            currentIndex: logic.index,
            onTap: (value) {
              logic.changeIndex(index: value);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Home',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Profile',
                tooltip: 'Profile',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).focusColor,
            child: Center(
              child: Image.asset(
                'assets/images/qr.png',
                width: 30,
              ),
            ),
            onPressed: () {
              Get.to(() => QRViewExample());
            },
          ),
          body: logic.pages[logic.index],
        );
      },
    );
  }
}
