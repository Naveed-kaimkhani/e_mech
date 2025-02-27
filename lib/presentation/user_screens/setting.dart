import 'package:e_mech/presentation/user_screens/logout_popup.dart';
import 'package:e_mech/presentation/user_screens/setting_services_screen_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/services_n_setting_header.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/seller_screen_widget/custom_divider.dart';

class Setting extends StatelessWidget {
  Setting({super.key});

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
            height: 20.h,
          ),
          SettingServicesScreenWidget(
            text: "Our Services",
            icon: Icons.work,
            routeName: "Services",
          ),
          k,
          SettingServicesScreenWidget(
            text: "Change Password",
            icon: Icons.password_outlined,
            routeName: "PasswordOption",
          ),
          k,
           SettingServicesScreenWidget(
            text: "Transaction",
            icon: Icons.history,
            routeName:RoutesName.transaction,
          ),
          k,
          SettingServicesScreenWidget(
            text: "Privacy Policy",
            // imageURL: Images.wheel,
            icon: Icons.privacy_tip_outlined,
            routeName: "PrivacyPolicyScreen",
          ),
          k,
          SettingServicesScreenWidget(
            text: "Contact Us",
            // imageURL: Images.mechanic_pic,
            icon: Icons.phone,
            routeName: RoutesName.contactUs,
          ),
          k,
          SettingServicesScreenWidget(
            text: "About Us",
            // imageURL: Images.mechanic_pic,
            icon: Icons.admin_panel_settings,
            routeName: RoutesName.aboutUs,
          ),
          k,
          SizedBox(
            height: 30.h,
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
          ),
        ],
      ),
    );
  }
}
