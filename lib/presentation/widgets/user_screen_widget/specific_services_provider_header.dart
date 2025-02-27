import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/custom_text_style.dart';

class SpecificServicesProviderHeader extends StatelessWidget {
  String text;
  String imageUrl;

  SpecificServicesProviderHeader({
    required this.text,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.h,
        width: 355.w,
        padding: const EdgeInsets.only(top: 45, left: 30),
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
            InkWell(
              child: CircleAvatar(
                backgroundColor: Styling.primaryColor,
                radius: 20,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 26.h,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Image.asset(
              imageUrl,
              height: 60.h,
              width: 60.w,
            ),
            // SizedBox(
            //   width: 15.w,
            // ),
            Text(
              text,
              style: CustomTextStyle.font_25,
            ),
          ],
        ));
  }
}
