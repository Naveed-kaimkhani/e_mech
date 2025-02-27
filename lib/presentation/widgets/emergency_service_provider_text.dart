import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyServiceProviderText extends StatelessWidget {
  const EmergencyServiceProviderText({super.key});

  @override
  Widget build(BuildContext context) {
    return  Text(
                "Emergency Service Provider",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black),
              );
  }
}