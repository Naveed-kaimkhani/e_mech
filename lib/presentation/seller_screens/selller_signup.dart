import 'dart:typed_data';
import 'package:e_mech/data/notification_services.dart';
import 'package:e_mech/presentation/seller_screens/seller_navigation.dart';
import 'package:e_mech/presentation/widgets/my_app_bar.dart';
import 'package:e_mech/utils/routes/routes_name.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../data/firebase_user_repository.dart';
import '../../domain/entities/seller_model.dart';
import '../../style/custom_text_style.dart';
import '../../style/styling.dart';
import '../../utils/storage_services.dart';
import '../../providers/seller_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/circle_progress.dart';
import '../widgets/inputfields.dart';

class SellerSignUp extends StatefulWidget {
  const SellerSignUp({Key? key}) : super(key: key);

  @override
  State<SellerSignUp> createState() => _SellerSignUpState();
}

class _SellerSignUpState extends State<SellerSignUp> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  final _formKey = GlobalKey<FormState>();
  String? service = "fuel";
  bool? obsecureText = true;
  bool isLoadingNow = false;
  bool _obsecureText = true;
  Uint8List? _profileImage;

  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode confirmFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode workshopFocusNode = FocusNode();
  FocusNode cNICFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _CNICController = TextEditingController();
  final TextEditingController _workshopController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  NotificationServices _notificationServices =NotificationServices();
  // final TextEditingController _addressController = TextEditingController();
  Widget k = SizedBox(
    height: 16.h,
  );
  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
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

  Future<void> _signup() async {
    isLoading(true);
    _firebaseUserRepository
        .signUpUser(
      _emailController.text,
      _passwordController.text,
      context,
    )
        .then((User? user) async {
      if (user != null) {
        final Position sellerLocation = await Geolocator.getCurrentPosition();
        final String address = await utils.getAddressFromLatLng(
            sellerLocation.latitude, sellerLocation.longitude);
        SellerModel sellerModel = SellerModel(
          uid: utils.currentUserUid,
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          CNIC: _CNICController.text,
          address: address,
          lat: sellerLocation.latitude,
          long: sellerLocation.longitude,
          workshopName: _workshopController.text,
          service: service,
          profileImage: await _firebaseUserRepository.uploadProfileImage(
              imageFile: _profileImage!, uid: user.uid),
        deviceToken:await _notificationServices.getDeviceToken() 
        );
        _saveSeller(user, sellerModel);
      } else {
        isLoading(false);
      }
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  void _saveSeller(User firebaseUser, SellerModel sellerModel) {
    _firebaseUserRepository
        .saveSellerDataToFirestore(sellerModel)
        .then((value) async {
      await StorageService.saveSeller(sellerModel).then((value) async {
        //await  StorageService.readUser();
        await Provider.of<SellerProvider>(context, listen: false)
            .getSellerLocally();
        await _firebaseUserRepository.loadSellerDataOnAppInit(context);

        isLoading(false);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SellerNavigation()));
      });
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _workshopController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _CNICController.dispose();

    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    workshopFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmFocusNode.dispose();
    cNICFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    utils.checkConnectivity(context);
    super.initState();
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
                Navigator.pushNamed(context, RoutesName.sellerLogin);
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
                              style: CustomTextStyle.font_30,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '\nAs a Seller',
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
                        hint_text: "CNIC",
                        currentNode: cNICFocusNode,
                        focusNode: cNICFocusNode,
                        nextNode: workshopFocusNode,
                        controller: _CNICController,
                        obsecureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter CNIC";
                          } else if (value.length != 13) {
                            return "Invalid CNIC";
                          } else {
                            return null;
                          }
                        },
                      ),
                      k,
                      InputField(
                        hint_text: "WorkShop Name",
                        currentNode: workshopFocusNode,
                        focusNode: workshopFocusNode,
                        nextNode: nameFocusNode,
                        controller: _workshopController,
                        obsecureText: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter WorkShop Name";
                          } else {
                            return null;
                          }
                        },
                      ),

                      k,

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
                        nextNode: phoneFocusNode,
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
                        currentNode: phoneFocusNode,
                        focusNode: phoneFocusNode,
                        nextNode: passwordFocusNode,
                        controller: _phoneController,
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
                        nextNode: confirmFocusNode,
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
                        currentNode: confirmFocusNode,
                        focusNode: confirmFocusNode,
                        nextNode: confirmFocusNode,
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
                      // k,
                      SizedBox(
                        height: 8.h,
                      ),

                      genderSelection(),
                      SizedBox(
                        height: 8.h,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: isLoadingNow
                            ? const CircleProgress()
                            : AuthButton(
                                text: "Signup",
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
              value: 'Mechanic',
              groupValue: service,
              onChanged: (value) {
                setState(() {
                  service = value!;
                });
              },
            ),
            const Text('Mechanic'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              activeColor: Styling.primaryColor,
              value: 'Fuel',
              groupValue: service,
              onChanged: (value) {
                setState(() {
                  service = value!;
                });
              },
            ),
            const Text('Fuel'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              // fillColor: Styling.primaryColor,
              activeColor: Styling.primaryColor,
              value: 'Puncture',
              groupValue: service,
              onChanged: (value) {
                setState(() {
                  service = value!;
                });
              },
            ),
            const Text('Puncture'),
          ],
        ),
      ],
    );
  }
}
