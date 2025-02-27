import 'package:e_mech/presentation/widgets/auth_button.dart';
import 'package:e_mech/presentation/widgets/circle_progress.dart';
import 'package:e_mech/presentation/widgets/inputfields.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'style/styling.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  Future<void> sentLink(String email) async {
    if (!EmailValidator.validate(email)) {
      utils.toastMessage('Invalid Email');
      utils.flushBarErrorMessage("Invalid Email", context);
    } else {
      await auth.sendPasswordResetEmail(email: email).then((Value) {
        utils.toastMessage('Sent a link to your Email');
      }).onError((error, stackTrace) {
        utils.flushBarErrorMessage("Something went wrong", context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // appBar: custom_appbar(),
      appBar: AppBar(
        title: Text("Reset Password"), // Add the title here
        backgroundColor: Styling.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 41.w, right: 41.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 27.h,
            ),
            Text(
              "Enter your email address to get a link to reset your password. ",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 67.h,
            ),
            InputField(
              hint_text: "Enter your email",
              focusNode: null,
              nextNode: null,
              controller: _emailController,
              currentNode: null,
            ),
            SizedBox(
              height: 19.h,
            ),
            isLoading
                ? CircleProgress()
                : AuthButton(
                    text: "Send Code",
                    func: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      // _emailController.clear();
                      await sentLink(_emailController.text);
                      _emailController.clear();
                    },
                    color: Styling.primaryColor,
                  ),
          ],
        ),
      ),
    ));
  }
}
