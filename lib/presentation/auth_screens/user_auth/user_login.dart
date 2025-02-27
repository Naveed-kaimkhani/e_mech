import 'package:e_mech/navigation_page.dart';
import 'package:e_mech/presentation/widgets/circle_progress.dart';
import 'package:e_mech/presentation/widgets/inputfields.dart';
import 'package:e_mech/presentation/widgets/my_app_bar.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/images.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/user_model.dart';
import '../../../style/styling.dart';
import '../../../utils/storage_services.dart';
import '../../widgets/auth_button.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final FirebaseUserRepository _firebaseRepository = FirebaseUserRepository();
  final _formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool? obsecureText = true;
  bool isLoadingNow = false;
  bool _obsecureText = true;
  Widget k = SizedBox(
    height: 16.h,
  );

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  void _login() {
    isLoading(true);
    _firebaseRepository
        .login(_emailController.text, _passwordController.text, context)
        .then((User? user) async {
      if (user != null) {
        _getUserDetails(user.uid);
      } else {
        isLoading(false);
        utils.flushBarErrorMessage("User is null", context);
      }
    });
  }

  void _getUserDetails(String uid) {
    _firebaseRepository.getUser().then((UserModel? userModel) {
      if (userModel != null) {
        StorageService.saveUser(userModel).then((value) async {
          await _firebaseRepository.loadDataOnAppInit(context);

          await StorageService.initUser();
          isLoading(false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPage()));
        }).catchError((error) {
          isLoading(false);

          utils.flushBarErrorMessage(error.message.toString(), context);
        });
      } else {
        isLoading(false);
        utils.flushBarErrorMessage("User is null", context);
      }
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    utils.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(
              text: "SignUp",
              onSignUpOrLoginPressed: () {
                Navigator.pushNamed(context, RoutesName.userSingup);
              },
              onBackButtonPressed: () {
                Navigator.pop(context);
              }),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 24.w, top: 8.h, right: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.logo,
                      height: 120.h,
                      width: 120.w,
                    ),
                    Text.rich(TextSpan(
                        text: 'Proceed With Your ',
                        style: CustomTextStyle.font_20,
                        children: <InlineSpan>[
                          TextSpan(
                            text: '\nLogin',
                            style: CustomTextStyle.font_30,
                          )
                        ])),
                    k,
                    InputField(
                      hint_text: "Email",
                      currentNode: emailFocusNode,
                      focusNode: emailFocusNode,
                      nextNode: passwordFocusNode,
                      controller: _emailController,
                      obsecureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter email address";
                        } else if (!EmailValidator.validate(value)) {
                          return "Invalid email address";
                        }
                      },
                    ),
                    k,
                    InputField(
                      hint_text: "Password",
                      currentNode: passwordFocusNode,
                      focusNode: passwordFocusNode,
                      nextNode: passwordFocusNode,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      icon: obsecureText!
                          ? Icons.visibility_off
                          : Icons.remove_red_eye,
                      obsecureText: obsecureText,
                      onIconPress: () {
                        setState(() {
                          obsecureText = !obsecureText!;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter password";
                        } else if (value.length < 6) {
                          return "password must be of 6 characters";
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, left: 200.w),
                      child: InkWell(
                        child: Text(
                          "Forgot Password",
                          style: CustomTextStyle.font_14_red,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesName.ForgetPasswordScreen);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Center(
                      child: isLoadingNow
                          ? const CircleProgress()
                          : AuthButton(
                              text: "Login",
                              func: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _submitForm();
                              },
                              color: Styling.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onIconPress() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }
}
