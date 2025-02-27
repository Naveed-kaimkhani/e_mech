import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/ride_cancel_popup.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';
import '../../../domain/entities/seller_model.dart';
import '../../../providers/seller_provider.dart';
import '../../seller_screens/SellerSideChatScreen.dart';
import '../request_widget_button.dart';

String timeSelected = '';
bool isTimeSelected = false;

class RequestWidget extends StatefulWidget {
  final RequestModel requestModel;

  RequestWidget({
    Key? key,
    required this.requestModel,
  }) : super(key: key);

  // bool? isAccepted = false;
  // String text = "Accepted";
  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  @override
  Widget build(BuildContext context) {
    SellerModel? seller =
        Provider.of<SellerProvider>(context, listen: false).seller;

    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      height: 135.h,
      width: 355.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.redAccent),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, top: 4.h),
                    child: ProfilePic(
                      height: 40.h,
                      width: 47.w,
                      url: widget.requestModel.senderProfileImage!,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    // widget.requestModel!.senderName!,
                    widget.requestModel.senderName!.split(' ')[0] ??
                        "No Sender Name",
                    style: CustomTextStyle.font_20,
                  ),
                ],
              ),
              SizedBox(
                width: 16.w,
              ),
              Row(
                children: [
                  Icon(
                    Icons.mode_of_travel_rounded,
                    color: Styling.primaryColor,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  widget.requestModel.distance!.length == 1
                      ? Text(
                          "${double.parse(widget.requestModel.distance!) / 1000} km")
                      : Text(
                          "${(widget.requestModel.distance ?? 0 / 1000).toString().substring(0, widget.requestModel.distance.toString().length ~/ 3)} km",
                          style: TextStyle(),
                        ),
                ],
              ),
              SizedBox(
                width: 3.w,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
// Navigating to a new screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SellerSideChatScreen(
                            user: widget.requestModel,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.chat),
                    color: Styling.primaryColor,
                    iconSize: 30.h,
                  ),
                  CallWidget(
                    num: widget.requestModel.senderPhone!,
                    context: context,
                    radius: 20.r,
                    iconSize: 16.h,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Required",
                        style: CustomTextStyle.font_15_black,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.requestModel.serviceRequired ??
                                "Service Null",
                            style: CustomTextStyle.font_12_red,
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          InkWell(
                            child: Icon(
                              Icons.description,
                              color: Styling.primaryColor,
                            ),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: widget.requestModel.description ??
                                      "No Description",
                                  toastLength: Toast.LENGTH_LONG);
                            },
                          ),
                        ],
                      ),

                      Text(
                        widget.requestModel.vehicle ?? "",
                        style: CustomTextStyle.font_12_red,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),

                      Text(
                          "${widget.requestModel.sentDate}  ${widget.requestModel.sentTime} ",
                          style: CustomTextStyle.font_10_black),
                      // Text(
                      //   "petrol",
                      //   style: CustomTextStyle.font_14_red,
                      // ),
                    ],
                  ),
                  isTimeSelected
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: RequestWidgetButton(
                                    text: "Delete",
                                    color: Styling.primaryColor),
                                onTap: () async {
                                  await FirebaseUserRepository
                                      .deleteRequestDocument(
                                          "Request",
                                          widget.requestModel.documentId!,
                                          context);
                                },
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              InkWell(
                                child: RequestWidgetButton(
                                    text: "Accept", color: Colors.black),
                                onTap: () async {
                                  showRideCancelPopup("Request Accepted",
                                      "Go to Accepted Request", context);
                                  // utils.showLoading(context);
                                  await FirebaseUserRepository.acceptRequest(
                                      widget.requestModel,
                                      timeSelected,
                                      context);
                                  await FirebaseUserRepository
                                      .notifyUserOnRequestAccepted(
                                          widget
                                              .requestModel.senderDeviceToken!,
                                          seller!.name!);
                                },
                              )
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // timebutton(
                            //   time: "15 mint",
                            // ),
                            InkWell(
                              child: Container(
                                height: 40.w,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: Styling.primaryColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                    child: Text("15 min",
                                        style: CustomTextStyle.font_12_white)),
                              ),
                              onTap: () {
                                setState(() {
                                  timeSelected = '15 min';
                                  isTimeSelected = true;
                                });

                                // setState(() {});
                              },
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            InkWell(
                              child: Container(
                                height: 40.w,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: Styling.primaryColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                    child: Text("30 min",
                                        style: CustomTextStyle.font_12_white)),
                              ),
                              onTap: () {
                                setState(() {
                                  timeSelected = '30 min';
                                  isTimeSelected = true;
                                });

                                // setState(() {});
                              },
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            InkWell(
                              child: Container(
                                height: 40.w,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: Styling.primaryColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                    child: Text("45 min",
                                        style: CustomTextStyle.font_12_white)),
                              ),
                              onTap: () {
                                setState(() {
                                  timeSelected = '45 min';
                                  isTimeSelected = true;
                                });

                                // setState(() {});
                              },
                            ),
                          ],
                        ),
                ]),
          ),
        ],
      ),
    );
  }
}
