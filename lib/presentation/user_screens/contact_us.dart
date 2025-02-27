import 'package:e_mech/style/images.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/user_screen_widget/services_n_setting_header.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key? key}) : super(key: key);
  SizedBox k = SizedBox(
    height: 20.h,
  );
  SizedBox l = SizedBox(
    height: 10.h,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Styling.primaryColor,
        title: Text('Contact Us'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BackButton(),
          SvgPicture.asset(
            Images.aboutUs,
            // color: Colors.white,
            height: 186.h,
            width: 268.w,
          ),
          k,
          Icon(
            Icons.location_on_outlined,
            color: Styling.primaryColor,
          ),
          l,
          Text(
            "Our Office Located near the Mehran University of Engineering and Technology,\n and Society, Jamshoro ",
            textAlign: TextAlign.center,
          ),
          k,
          Icon(
            Icons.phone,
            color: Styling.primaryColor,
          ),
          l,
          Center(
            child: Text(
              "03361832730",
              textAlign: TextAlign.center,
            ),
          ),
          k,
          Icon(
            Icons.mail,
            color: Styling.primaryColor,
          ),
          l,
          Text(
            "EMECH.CUSTOMERCARE@GMAIL.COM",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
