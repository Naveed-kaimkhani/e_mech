import 'dart:typed_data';
import 'package:e_mech/presentation/widgets/circle_progress.dart';
import 'package:e_mech/presentation/widgets/inputfields.dart';
import 'package:e_mech/presentation/widgets/my_app_bar.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../data/notification_services.dart';
import '../../../domain/entities/user_model.dart';
import '../../../navigation_page.dart';
import '../../../style/styling.dart';
import '../../../utils/storage_services.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/auth_button.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // utils.checkConnectivity(context);
  }

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmpasswordFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  NotificationServices notificationServices = NotificationServices();

  bool? obsecureText = true;
  bool isLoadingNow = false;
  bool _obsecureText = true;
  Uint8List? _profileImage;
  String gender = "male";
  Widget k = SizedBox(
    height: 16.h,
  );
  @override
  void dispose() {
    confirmpasswordFocusNode.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    numberFocusNode.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  void _signup() {
    // utils.showLoading(context);
    isLoading(true);
    _firebaseUserRepository
        .signUpUser(_emailController.text, _passwordController.text, context)
        .then((User? user) async {
      if (user != null) {
        UserModel userModel = UserModel(
            uid: user.uid,
            lastActive: '',
            isOnline: false,
            name: _nameController.text,
            phone: _numberController.text,
            email: _emailController.text,
            gender: gender,
            profileImage: await _firebaseUserRepository.uploadProfileImage(
                imageFile: _profileImage!, uid: user.uid),
            deviceToken: await notificationServices.getDeviceToken());
        _saveUser(user, userModel);
      } else {
        isLoading(false);
        // utils.hideLoading();
        utils.flushBarErrorMessage('Failed to Signup', context);
      }
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  void _saveUser(User firebaseUser, UserModel userModel) {
    _firebaseUserRepository
        .saveUserDataToFirestore(userModel)
        .then((value) async {
      await StorageService.saveUser(userModel).then((value) async {
        Provider.of<UserProvider>(context, listen: false).getUserLocally();
        isLoading(false);
        await StorageService.initUser();

        await _firebaseUserRepository.loadDataOnAppInit(context);
        isLoading(false);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavigationPage()));
      }).catchError((error) {
        isLoading(false);
        utils.flushBarErrorMessage(error.message.toString(), context);
      });
    });
  }

  void _submitForm() {
    if (_profileImage == null) {
      utils.flushBarErrorMessage("Please upload profile", context);
    } else if (_formKey.currentState!.validate()) {
      // Form is valid, perform signup logic here
      _signup();
      // Perform signup logic
      // ...
    }
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
              text: "Login",
              onSignUpOrLoginPressed: () {
                Navigator.pushNamed(context, RoutesName.userLogin);
              },
              onBackButtonPressed: () {
                Navigator.pop(context);
              }),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 22, top: 16, right: 18),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Sign-Up',
                              style: CustomTextStyle.font_20,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '\nAs a User',
                                  style: CustomTextStyle.font_20,
                                )
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: uploadProfile(_profileImage),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.16.h,
                      ),
                      InputField(
                        hint_text: "Full name",
                        currentNode: nameFocusNode,
                        focusNode: nameFocusNode,
                        nextNode: emailFocusNode,
                        controller: _nameController,
                        obsecureText: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      k,
                      InputField(
                        hint_text: "Email address",
                        currentNode: emailFocusNode,
                        focusNode: emailFocusNode,
                        nextNode: numberFocusNode,
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
                        hint_text: "Phone",
                        currentNode: numberFocusNode,
                        focusNode: numberFocusNode,
                        nextNode: passwordFocusNode,
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        obsecureText: false,
                        preicon: SizedBox(
                          width: 60.w,
                          height: 40.h,
                          child: Row(
                            children: [
                              Text(
                                "  +92",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                              VerticalDivider(
                                thickness: 2.r,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter phone number";
                          } else if (value.length != 10) {
                            return "Invalid phone number";
                          }
                        },
                      ),
                      k,
                      InputField(
                        hint_text: "Set password",
                        currentNode: passwordFocusNode,
                        focusNode: passwordFocusNode,
                        nextNode: confirmpasswordFocusNode,
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
                      k,
                      InputField(
                        hint_text: "Confirm password",
                        currentNode: confirmpasswordFocusNode,
                        focusNode: confirmpasswordFocusNode,
                        nextNode: confirmpasswordFocusNode,
                        controller: _confirmpasswordController,
                        obsecureText: _obsecureText,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter password to confirm";
                          } else if (value != _passwordController.text) {
                            return "Password not match";
                          }
                        },
                      ),
                      k,
                      genderSelection(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: isLoadingNow
                            ? const CircleProgress()
                            : AuthButton(
                                text: "Signup",
                                func: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // _signup();
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
      ),
    );
  }

  void onIconPress() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  Widget uploadProfile(Uint8List? image) {
    return image == null
        ? Stack(
            children: [
              // Image.network(
              //   "https://m.media-amazon.com/images/I/11uufjN3lYL._SX90_SY90_.png",
              //   height: 60,
              // ),
              Image.asset(
                "assets/avatar.png",
                height: 60.h,
                width: 60.w,
              ),
              Positioned(
                left: 25.w,
                bottom: 0.h,
                child: IconButton(
                  onPressed: () async {
                    Uint8List? _image = await utils.pickImage();
                    if (_image != null) {
                      setState(() {
                        _profileImage = _image;
                      });
                    } else {
                      debugPrint("Image not loaded");
                    }
                  },
                  icon: Container(
                    width: 25.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Styling.primaryColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      child: Image.asset('assets/gallery.png'),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              CircleAvatar(
                minRadius: 40.r,
                maxRadius: 40.r,
                child: ClipOval(
                    child: Image.memory(
                  image,
                  height: 145.h,
                  width: 145.w,
                  fit: BoxFit.cover,
                )),
                // child: ,
              ),
              Positioned(
                left: 45.w,
                bottom: 0.h,
                child: IconButton(
                  onPressed: () async {
                    Uint8List? _image = await utils.pickImage();
                    if (_image != null) {
                      setState(() {
                        image = _image;
                      });
                    }
                    debugPrint("Image not loaded");
                  },
                  icon: Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Styling.primaryColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Image.asset('assets/gallery.png'),
                    ),
                  ),
                ),
              ),
            ],
          );
  } // for 1st image

  Widget genderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              activeColor: Styling.primaryColor,
              value: 'female',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Text('Female'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              // fillColor: Styling.primaryColor,
              activeColor: Styling.primaryColor,
              value: 'male',
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const Text('Male'),
          ],
        ),
      ],
    );
  }
}
