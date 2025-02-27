import 'package:e_mech/presentation/seller_screens/accepted_request.dart';
import 'package:e_mech/presentation/seller_screens/seller_homepage.dart';
import 'package:e_mech/presentation/seller_screens/seller_profile.dart';
import 'package:e_mech/presentation/user_screens/setting.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SellerNavigation extends StatefulWidget {
  const SellerNavigation({Key? key}) : super(key: key);
  @override
  State<SellerNavigation> createState() => _SellerNavigationState();
}

class _SellerNavigationState extends State<SellerNavigation> {
  List pages = [
    const SellerHomepage(),
    const AcceptedRequest(),
    SellerProfile(),
    Setting(),
  ];
  int currentindex = 0;
  void onTap(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Styling.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
        // padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.h),

        child: GNav(
          backgroundColor: Styling.primaryColor,
          color: Colors.white,
          activeColor: Styling.primaryColor,
          tabBackgroundColor: Colors.white,
          padding: const EdgeInsets.all(6),
          gap: 8,
          onTabChange: onTap,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.done_outline_outlined,
              text: "Accepted",
            ),
            GButton(
              icon: Icons.account_circle_outlined,
              text: "Profile",
            ),
            GButton(
              icon: Icons.settings_outlined,
              text: "Setting",
            ),
          ],
        ),
      ),
      body: pages[currentindex],
    );
  }
}
