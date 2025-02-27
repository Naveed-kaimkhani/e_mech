import 'package:e_mech/presentation/seller_screens/seller_user_tracing.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/widgets/request_widget_button.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/invoice.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';

class AcceptedRequestWidget extends StatefulWidget {
  final RequestModel requestModel;
  AcceptedRequestWidget({
    Key? key,
    required this.requestModel,
  }) : super(key: key);
  @override
  State<AcceptedRequestWidget> createState() => _AcceptedRequestWidgetState();
}

class _AcceptedRequestWidgetState extends State<AcceptedRequestWidget> {
  // final FirebaseUserRepository _firebaseRepository = FirebaseUserRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      height: 119.h,
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
                      width: 46.w,
                      url: widget.requestModel.senderProfileImage!,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.requestModel.senderName ?? "No Sender Name",
                    style: CustomTextStyle.font_20,
                  ),
                ],
              ),
              SizedBox(
                width: 20.w,
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
                      ? Text("${widget.requestModel.distance!} km")
                      : Text(
                          "${(widget.requestModel.distance ?? 0 / 1000).toString().substring(0, widget.requestModel.distance.toString().length ~/ 3)} km",
                          style: TextStyle(),
                        ),
                ],
              ),
              CallWidget(
                  iconSize: 22.h,
                  radius: 24.r,
                  num: widget.requestModel.senderPhone!,
                  context: context),
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
                      Text(
                        widget.requestModel.serviceRequired ?? "Service Null",
                        style: CustomTextStyle.font_14_red,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                          "${widget.requestModel.sentDate}  ${widget.requestModel.sentTime} ",
                          style: CustomTextStyle.font_10_black),
                    ],
                  ),
                  widget.requestModel.status == "accepted"
                      ? Row(
                          children: [
                            MarkCompleted(widget: widget),
                            SizedBox(
                              width: 5.w,
                            ),
                            GotoLocationbttn(widget: widget),
                          ],
                        )
                      : letuseraccept()
                ]),
          )
        ],
      ),
    );
  }
}

class letuseraccept extends StatelessWidget {
  const letuseraccept({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      width: 110.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r), color: Colors.black),
      child: Center(
        child: Text(
          "Let User Confirm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GotoLocationbttn extends StatelessWidget {
  const GotoLocationbttn({
    super.key,
    required this.widget,
  });

  final AcceptedRequestWidget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: request_widget_button(
        text: "Location",
        color: Colors.black,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SellerUserTracing(
                    requestModel: widget.requestModel,
                  )),
        );
      },
    );
  }
}

class MarkCompleted extends StatelessWidget {
  const MarkCompleted({
    super.key,
    required this.widget,
  });

  final AcceptedRequestWidget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: request_widget_button(
        text: "Completed",
        color: Styling.primaryColor,
      ),
      onTap: () async {
        if (widget.requestModel.completed == "completed") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvoiceScreen(
                      requestModel: widget.requestModel,
                    )),
          );
        } else {
          utils.toastMessage("Let User Confirm First");
        }
      },
    );
  }
}

class request_widget_button extends StatelessWidget {
  String text;
  Color color;
  request_widget_button({
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 90.w,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
