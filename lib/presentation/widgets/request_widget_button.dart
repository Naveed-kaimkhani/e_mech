import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestWidgetButton extends StatelessWidget {
  String text;
  Color color;
  RequestWidgetButton({
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      width: 86.w,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
