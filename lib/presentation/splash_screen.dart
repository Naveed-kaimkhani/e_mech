import 'dart:async';
import 'package:e_mech/data/notification_services.dart';
import 'package:e_mech/presentation/seller_screens/seller_navigation.dart';
import 'package:e_mech/presentation/user_or_seller.dart';
import 'package:e_mech/presentation/widgets/emergency_service_provider_text.dart';
import 'package:e_mech/utils/storage_services.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../data/firebase_user_repository.dart';
import '../navigation_page.dart';
import '../style/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  NotificationServices _notificationServices =NotificationServices();
  @override
  void initState() {
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    // _notificationServices.getDeviceToken().then((value) {
    // });
    utils.checkConnectivity(context);
    
    Timer(const Duration(seconds: 2), () {
    loadData();
  });
  super.initState();
  }

  loadData() async {
    User? user=utils.getCurrentUser();
    int? isUser= await StorageService.checkUserInitialization();

    try {
if (user!=null ) {
  if (isUser==1 && isUser!=null) {
  await  _firebaseUserRepository.loadDataOnAppInit(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
  }else{
    await _firebaseUserRepository.loadSellerDataOnAppInit(context);
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerNavigation()),
      );
  }
} else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserSellerScreen()),
      );
}
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      // Handle error if any
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 250.w,
            ),
            Image.asset(
              Images.logo,
              height: 180.h,
              width: 180.w,
            ),
            SizedBox(
              height: 230.w,
            ),
            const EmergencyServiceProviderText(),
            const Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SpinKitSpinningLines(
                color: Colors.black,
                size: 30.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}