import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/custom_text_style.dart';

class ServicesNSettingHeader extends StatelessWidget {
  String text;
IconData icon;
  ServicesNSettingHeader({
    required this.text,
   required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.h,
        width: 355.w,
        padding: EdgeInsets.only(top: 45, left: 50),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30.h,
              color: Styling.primaryColor,
            ),
            SizedBox(
              width: 25.w,
            ),
            Text(
              text,
              style: CustomTextStyle.font_25,
            ),
          ],
        ));
  }
}
