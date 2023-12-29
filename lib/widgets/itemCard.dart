import 'package:finale_proj/widgets/imageLoading.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemCard extends StatelessWidget {
  ItemCard(
      {super.key,
      required this.onTap,
      required this.image,
      required this.name,
      this.onLongPress});

  String name;
  String image;
  void Function()? onTap;
  void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyImageWidget(
                  width: 50,
                  hieght: 50,
                  imageUrl: '${image}',
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${name}',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
