import 'package:e_mech/providers/all_sellerdata_provider.dart';
import 'package:e_mech/providers/seller_provider.dart';
import 'package:e_mech/providers/user_provider.dart';
import 'package:e_mech/presentation/splash_screen.dart';
import 'package:e_mech/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// GetIt getIt = GetIt.instance;
late Size mq;

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // print(message.notification!.title);
//   await Firebase.initializeApp();
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
            mq = MediaQuery.of(context).size;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => SellerProvider()),
            ChangeNotifierProvider(create: (_) => AllSellerDataProvider()),
          ],
          child: MaterialApp(
            title: 'E-Mech',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:SplashScreen(),
            
            onGenerateRoute: Routes.onGenerateRoute,
          ),
        );
      },
      // child:

    );
  }
}
