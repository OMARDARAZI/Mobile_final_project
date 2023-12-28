import 'package:finale_proj/home/view.dart';
import 'package:finale_proj/profile/view.dart';
import 'package:get/get.dart';

class NavBarLogic extends GetxController {

  int index = 0;

  var pages=[
    HomePage(),
    ProfilePage(),
  ];

  changeIndex({required int index}){
    this.index=index;
    update();
  }
}
