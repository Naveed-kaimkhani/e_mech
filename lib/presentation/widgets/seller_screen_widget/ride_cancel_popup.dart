import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/custom_text_style.dart';

showRideCancelPopup(String text1, String text2, context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 100.h,
            width: 190.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1,
                  style: CustomTextStyle.font_20_red,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  text2,
                  style: CustomTextStyle.font_15_black,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  height: 30.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      color: Styling.primaryColor,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: InkWell(
                    child: Center(
                        child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    )),
                    onTap: () => Navigator.pop(context),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
