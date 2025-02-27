import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/presentation/seller_screens/seller_user_tracing.dart';
import 'package:e_mech/presentation/user_screens/rating_screen.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/mechanic_tracking_at_user_side.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../domain/entities/request_model.dart';

class UserAcceptedRequestWidget extends StatefulWidget {
  final RequestModel requestModel;

  UserAcceptedRequestWidget({
    Key? key,
    required this.requestModel,
  }) : super(key: key);
  @override
  State<UserAcceptedRequestWidget> createState() =>
      _UserAcceptedRequestWidgetState();
}

class _UserAcceptedRequestWidgetState extends State<UserAcceptedRequestWidget> {
  // final FirebaseUserRepository _firebaseRepository = FirebaseUserRepository();
  SellerModel? sellerData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseUserRepository()
        .getSellerDetailsUsingID(widget.requestModel.receiverUid!)
        .then((seller) {
      sellerData = seller;
      setState(() {});
    });
  }

  bool isAccpeted = false;
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
                      url: widget.requestModel.mechanicProfile,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.requestModel.mechanicName!.split(' ')[0] ??
                            "No Name",
                        style: CustomTextStyle.font_18_black,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          AbsorbPointer(
                            child: SizedBox(
                              height: 14.h,
                              child: FittedBox(
                                child: RatingBar(
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.amber.shade600,
                                      size: 8,
                                    ),
                                    half: Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.amber.shade600,
                                      size: 8,
                                    ),
                                    empty: Icon(
                                      Icons.star_border_rounded,
                                      color: Colors.grey,
                                      size: 8,
                                    ),
                                  ),
                                  initialRating: sellerData != null
                                      ? sellerData!.rating ?? 0
                                      : 0,
                                  onRatingUpdate: (v) {},
                                ),
                              ),
                            ),
                          ),
                          Text(
                            " (" +
                                (sellerData != null
                                        ? sellerData!.numberOfRatings ?? 0
                                        : 0)
                                    .toString()
                                    .split('.')
                                    .first +
                                ")",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  request_widget_button(
                    text:
                        "${(double.parse(widget.requestModel.distance!) / 1000).toStringAsFixed(2)} km",
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  request_widget_button(
                    text: "${widget.requestModel.timeRequired!}",
                    color: Colors.black,
                  ),
                ],
              ),
              // Text(widget.requestModel.timeRequired!)
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
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
                        height: 10.h,
                      ),
                      Text(
                          "${widget.requestModel.sentDate}  ${widget.requestModel.sentTime} ",
                          style: CustomTextStyle.font_10_black),
                    ],
                  ),
                  // MarkCompleted(widget: widget),
                  SizedBox(
                    height: 3.h,
                  ),
                  isAccpeted || widget.requestModel.status == "accepted"
                      ? Row(
                          children: [
                            InkWell(
                              child: request_widget_button(
                                text: "Completed",
                                color: Styling.primaryColor,
                              ),
                              onTap: () async {
                                await FirebaseUserRepository
                                        .markRequestCompletedFromUserSide(
                                            widget.requestModel, context)
                                    .then((value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RatingScreen(
                                                request:
                                                    widget.requestModel))));
                              },
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            GotoLocationbttn(widget: widget),
                          ],
                        )
                      : Row(
                          children: [
                            InkWell(
                              child: request_widget_button(
                                  text: "Yes", color: Styling.primaryColor),
                              onTap: () async {
                                await FirebaseUserRepository
                                    .updateRequestStatus(
                                        widget.requestModel, context);
                                setState(() {
                                  isAccpeted = true;
                                });
                              },
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            InkWell(
                              child: request_widget_button(
                                  text: "No", color: Styling.primaryColor),
                              onTap: () async {
                                await FirebaseUserRepository.deleteRequest(
                                    widget.requestModel, context);
                              },
                            ),
                          ],
                        )
                ]),
          )
        ],
      ),
    );
  }
}

class GotoLocationbttn extends StatelessWidget {
  const GotoLocationbttn({
    super.key,
    required this.widget,
  });

  final UserAcceptedRequestWidget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: request_widget_button(
        text: "Track Mech",
        color: Colors.black,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MechanicTrackingAtUserSide(
                    requestModel: widget.requestModel,
                  )),
        );
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
      width: 85.w,
      padding: EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: color),
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
