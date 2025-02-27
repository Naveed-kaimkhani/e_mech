import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class shimmerForChatUser extends StatelessWidget {
  shimmerForChatUser({Key? key}) : super(key: key);
  final Decoration k = BoxDecoration(
    borderRadius: BorderRadius.circular(6.r),
    color: Colors.grey.withOpacity(0.5),
  );
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
              height: 60.h,
              width: 60.w,
            padding: const EdgeInsets.only(left: 1.0, top: 8.0),
            decoration: BoxDecoration(
              // color: Colors.white,
              border: Border.all(width: 2, color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      height: 33.h,
                      width: 132.w,
                      decoration: k,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      height: 23.h,
                      width: 103.w,
                      decoration: k,
                    ),                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
