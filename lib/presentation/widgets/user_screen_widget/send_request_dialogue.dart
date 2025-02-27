import 'dart:convert';

import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/domain/entities/user_model.dart';
import 'package:e_mech/providers/all_sellerdata_provider.dart';
import 'package:e_mech/presentation/widgets/circle_progress.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../general_bttn_for_userhmpg.dart';

class SendRequestDialogue extends StatefulWidget {
  @override
  _SendRequestDialogueState createState() => _SendRequestDialogueState();
}

class _SendRequestDialogueState extends State<SendRequestDialogue> {
  String _selectedService = "Mechanic";
  String _selectedVehicleType = "Car";
  TextEditingController controller = TextEditingController();
  bool isLoadingNow = false;
  // Updated _services list with unique items
  final List<String> _services = ['Mechanic', 'Puncture', 'Fuel'];
  final List<String> _vehicleTypes = ['Car', 'Motorcycle', 'Truck'];

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<SellerModel>? allSellers =
        Provider.of<AllSellerDataProvider>(context, listen: false).sellers;
    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;

    return Dialog(
      // shadowColor: Color.fromARGB(255, 135, 130, 130),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hire Mechanic",
              style: CustomTextStyle.font_20_red,
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedService,
                items: _services.map((service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(
                      service,
                      // style: TextStyle(color: Color.fromARGB(255, 101, 99, 99)),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedService = value!;
                  });
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    //<-- SEE HERE
                    borderSide:
                        BorderSide(color: Styling.primaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    //<-- SEE HERE
                    borderSide:
                        BorderSide(color: Styling.primaryColor, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedVehicleType,
              items: _vehicleTypes.map((vehicleType) {
                return DropdownMenuItem<String>(
                  value: vehicleType,
                  child: Text(vehicleType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVehicleType = value!;
                });
              },
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: Styling.primaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                    //<-- SEE HERE
                    // borderSide:
                    //     BorderSide(color: Styling.primaryColor, width: 2),
                    ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: 287.w,
              height: 65.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(
                  color: Styling.primaryColor,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLength: 150,
                  maxLines: 8,
                  controller: controller,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Describe Problem"),
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            InkWell(
              child: isLoadingNow
                  ? const CircleProgress()
                  : GeneralBttnForUserHmPg(
                      text: "Send Request",
                    ),
              onTap: () async {
                List<SellerModel> neededSellers =
                    filterSellersByService(allSellers!, _selectedService);

                if (neededSellers.isNotEmpty) {
                  await sendRequest(neededSellers, user!,_selectedVehicleType, controller.text);
                  Navigator.pop(context);
                  utils.openRequestSentDialogue(context);
                } else {
                  isLoading(false);
                  Navigator.pop(context);
                  utils.flushBarErrorMessage(
                      "No required Mechanic Available", context);
                }
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Styling.primaryColor, fontSize: 20.sp),
                ))
          ],
        ),
      ),
    );
  }

  filterSellersByService(List<SellerModel> sellers, String selectedService) {
    isLoading(true);
    return sellers
        .where((seller) => seller.service!.contains(selectedService))
        .toList();
  }

  sendRequest(List<SellerModel> sellers, UserModel user, String vehicleType, String description)async {
    RequestModel request = RequestModel(
        documentId: '',
        serviceId: utils.getRandomid(),
        senderUid: utils.currentUserUid,
        serviceRequired: _selectedService,
        senderName: user.name,
        senderPhone: user.phone,
        senderLat: user.lat,
        senderLong: user.long,
        // receiverUid: ,
        description: description,
        timeRequired: '0',
        status: "pending",
  vehicle: vehicleType,
        completed: "pending",
        senderAddress: user.address,
        senderDeviceToken: user.deviceToken,
        sentDate: utils.getCurrentDate(),
        sentTime: utils.getCurrentTime(),
        senderProfileImage: user.profileImage);
    await FirebaseUserRepository.sentRequest(sellers, request, context);
      isLoading(false);
  }
}
