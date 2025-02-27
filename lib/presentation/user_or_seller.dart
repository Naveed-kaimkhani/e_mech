import 'package:e_mech/presentation/widgets/emergency_service_provider_text.dart';
import 'package:e_mech/presentation/widgets/user_seller_component.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/images.dart';

class UserSellerScreen extends StatelessWidget {
  const UserSellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color(0xffF5AD0D),
        //        appBar: custom_appbar(),
        body: Padding(
          padding: EdgeInsets.only(left: 80.w, top: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserSellerComponent(
                image: 'assets/user.png',
                text: "User",
                ontap: () {
                  Navigator.pushNamed(context, RoutesName.userLogin);
                },
              ),
              SizedBox(
                height: 50.h,
              ),
              UserSellerComponent(
                  image: Images.seller,
                  text: "Seller",
                  ontap: () {
                    Navigator.pushNamed(context, RoutesName.sellerLogin);
                  }),
              SizedBox(
                height: 80.h,
              ),
              Image.asset(
                Images.eMech,
                height: 37.h,
                width: 129.w,
              ),
              const EmergencyServiceProviderText()
            ],
          ),
        ),
      ),
    );
  }
}
