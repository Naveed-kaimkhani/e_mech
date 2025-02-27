import 'package:e_mech/presentation/user_screens/logout_popup.dart';
import 'package:e_mech/presentation/user_screens/setting_services_screen_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/services_n_setting_header.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SellerSetting extends StatelessWidget {
  Divider k = const Divider(
    color: Color.fromARGB(255, 174, 171, 171), //color of divider
    height: 4, //height spacing of divider
    thickness: 1, //thickness of divier line
    indent: 25, //spacing at the start of divider
    endIndent: 25, //spacing at the end of divider
  );
  SellerSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ServicesNSettingHeader(
            text: "Setting",
            icon: Icons.settings_outlined,
          ),
          //  ServicesNSettingHeade(text: 'Setting Available'),
          SizedBox(
            height: 10.h,
          ),
          SettingServicesScreenWidget(
            text: "Change Password",
            icon: Icons.password_outlined,
            routeName: "",
          ),
          k,
          SettingServicesScreenWidget(
            text: "Privacy Policy",
            // imageURL: Images.wheel,
            icon: Icons.privacy_tip_outlined,
            routeName: " ",
          ),
          k,
          SettingServicesScreenWidget(
            text: "Contact Us",
            // imageURL: Images.mechanic_pic,
            icon: Icons.phone,
            routeName: RoutesName.generalMechanic,
          ),
          k,
          SettingServicesScreenWidget(
            text: "About Us",
            // imageURL: Images.mechanic_pic,
            icon: Icons.phone,
            routeName: RoutesName.generalMechanic,
          ),
          k,
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Icon(
                  Icons.logout_outlined,
                  color: Styling.primaryColor,
                  size: 25.h,
                ),
                Text(
                  "LogOut",
                  style: CustomTextStyle.font_20_red,
                )
              ],
            ),
            onTap: () {
              showLogoutPopup(context);
            },
          )
        ],
      ),
    );
  }
}
