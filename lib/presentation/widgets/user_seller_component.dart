import 'package:e_mech/style/styling.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSellerComponent extends StatelessWidget {
  final String image;
  final String text;
  final Function() ontap;
  const UserSellerComponent(
      {Key? key, required this.image, required this.text, required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            width: 160.w,
            height: 160.h,
            decoration: const BoxDecoration(
              color: Styling.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              image,
            ),
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Text(
          text,
          style: CustomTextStyle.font_20,
        )
      ],
    );
  }
}
