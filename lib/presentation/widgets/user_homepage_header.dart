import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../style/custom_text_style.dart';

class UserHomePageHeader extends StatelessWidget {
  String name;
  String text;
  String imageUrl;
  UserHomePageHeader({
    required this.name,
    required this.text,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        width: 355.w,
        padding: EdgeInsets.only(top: 18, left: 18),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hi $name',
                  style: CustomTextStyle.font_25,
                ),
                Text(
                  text,
                  style: CustomTextStyle.font_20,
                ),
              ],
            ),
            // SizedBox(
            //   width: 80.w,
            // ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: ProfilePic(url: imageUrl, height: 52.h, width: 58.w),
            ),
          ],
        ));
  }
}
