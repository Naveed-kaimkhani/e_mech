import 'dart:developer';

import 'package:e_mech/forget_password.dart';
import 'package:e_mech/presentation/auth_screens/seller_auth/seller_login.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_login.dart';
import 'package:e_mech/presentation/auth_screens/user_auth/user_signup.dart';
import 'package:e_mech/presentation/privacy_policy.dart';
import 'package:e_mech/presentation/seller_screens/selller_signup.dart';
import 'package:e_mech/presentation/user_screens/GeneralMechanic.dart';
import 'package:e_mech/presentation/user_screens/about_us.dart';
import 'package:e_mech/presentation/user_screens/contact_us.dart';
import 'package:e_mech/presentation/user_screens/password_option.dart';
import 'package:e_mech/presentation/user_screens/petrol_providers.dart';
import 'package:e_mech/presentation/user_screens/punture_maker.dart';
import 'package:e_mech/presentation/user_screens/services.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/transaction_screen.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.sellerLogin:
        return _buildRoute(const SellerLogin(), settings);
      case RoutesName.userLogin:
        return _buildRoute(const UserLogin(), settings);
      case RoutesName.userSingup:
        return _buildRoute(const UserSignup(), settings);
      case RoutesName.sellerSignup:
        return _buildRoute(const SellerSignUp(), settings);
      case RoutesName.passwordOption:
        return _buildRoute(const PasswordOption(), settings);
      case RoutesName.services:
        return _buildRoute(Services(), settings);
      case RoutesName.punctureMaker:
        return _buildRoute(const PunctureMaker(), settings);
      case RoutesName.petrolProviders:
        return _buildRoute(const PetrolProviders(), settings);
      case RoutesName.generalMechanic:
        return _buildRoute(const GeneralMechanic(), settings);
      case RoutesName.contactUs:
        return _buildRoute(ContactUs(), settings);
      case RoutesName.privacyPolicy:
        return _buildRoute(PrivacyPolicyScreen(), settings);
      case RoutesName.aboutUs:
        return _buildRoute(AboutUs(), settings);
     case RoutesName.transaction:
        return _buildRoute(TransactionScreen(), settings);
     case RoutesName.ForgetPasswordScreen:
        return _buildRoute(ForgetPasswordScreen(), settings);

      default:
        return _buildRoute(
            const Scaffold(
              body: Center(
                child: Text("NO Route Found"),
              ),
            ),
            settings);
    }
  }

  static _buildRoute(Widget widget, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => widget, settings: settings);
  }
}
