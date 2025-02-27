import 'package:e_mech/presentation/user_screens/setting_services_screen_widget.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../style/images.dart';
import '../widgets/user_screen_widget/services_n_setting_header.dart';

class Services extends StatelessWidget {
  Divider k = const Divider(
    color: Color.fromARGB(255, 174, 171, 171), //color of divider
    height: 4, //height spacing of divider
    thickness: 1, //thickness of divier line
    indent: 25, //spacing at the start of divider
    endIndent: 25, //spacing at the end of divider
  );
  Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ServicesNSettingHeader(
            text: 'Services Available',
            icon: Icons.grid_view_rounded,
          ),
          SizedBox(
            height: 10.h,
          ),
          SettingServicesScreenWidget(
            text: "Petrol",
            imageURL: Images.petrol,
            routeName: RoutesName.petrolProviders,
          ),
          k,
          SettingServicesScreenWidget(
            text: "Puncture",
            imageURL: Images.wheel,
            routeName: RoutesName.punctureMaker,
          ),
          k,
          SettingServicesScreenWidget(
            text: "General Mechanic",
            imageURL: Images.mechanic_pic,
            routeName: RoutesName.generalMechanic,
          ),
          k,
        ],
      ),
    );
  }
}
