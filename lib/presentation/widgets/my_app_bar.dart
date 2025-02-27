import 'package:e_mech/style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback onSignUpOrLoginPressed;
  final VoidCallback onBackButtonPressed;

  const MyAppBar({
    super.key,
    required this.text,
    required this.onSignUpOrLoginPressed,
    required this.onBackButtonPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20.h,
        ),
        onPressed: onBackButtonPressed,
        color: Colors.black,
      ),
      // title: Text(title),
      actions: [
        TextButton(
            onPressed: onSignUpOrLoginPressed,
            child: Text(
              text,
              style: CustomTextStyle.font_15,
            ))
      ],
    );
  }
}
