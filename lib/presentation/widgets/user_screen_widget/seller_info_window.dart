import 'package:e_mech/presentation/widgets/user_screen_widget/call_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/send_request_to_specific_seller.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/entities/seller_model.dart';
import '../../../style/custom_text_style.dart';
import '../profile_pic.dart';

class SellerInfoWindow extends StatefulWidget {
  SellerModel seller;
  double userLat;
  double userLong;
  SellerInfoWindow(
      {super.key,
      required this.seller,
      required this.userLat,
      required this.userLong});

  @override
  State<SellerInfoWindow> createState() => _SellerInfoWindowState();
}

class _SellerInfoWindowState extends State<SellerInfoWindow> {
  bool isRequestSend = false;

  double getDistancebtwRiderNSeller(
    double riderLat,
    double riderLong,
  ) {
    return Geolocator.distanceBetween(
        riderLat, riderLong, widget.seller.lat!, widget.seller.long!);
  }

  // "${(distance! / 1000).toString().substring(0, halfLength.toInt())} km"
  @override
  Widget build(BuildContext context) {
    double distance =
        getDistancebtwRiderNSeller(widget.userLat, widget.userLong);

    int midIndex =
        widget.seller.address!.length ~/ 2; // Calculate the middle index
    String address = widget.seller.address!.substring(0, midIndex);
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Container(
        padding:
            EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h, right: 10.w),
        // padding: EdgeInsets.all(20),
        height: 160.h,
        width: 310.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.w, color: Colors.redAccent),
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
                      child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 40.h,
                          width: 40.w,
                          child: ProfilePic(
                            height: 35.h,
                            width: 35.w,
                            url: widget.seller.profileImage,
                          )),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.,
                          children: [
                            Text(
                              // widget.requestModel!.senderName!,
                              widget.seller.name!.split(' ')[0] ??
                                  "No Sender Name",
                              style: CustomTextStyle.font_18_black,
                            ),
                            SizedBox(
                              width: 18.w,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.mode_of_travel_rounded,
                                  color: Styling.primaryColor,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  "${(distance / 1000).toString().substring(0, distance.toString().length ~/ 3)} km",
                                  style: TextStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Styling.primaryColor,
                              size: 12.h,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              // widget.seller.workshopName!,
                              address.substring(
                                  0, (address.length / 2).round()),
                              style: CustomTextStyle.font_15_black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // CallWidget(num: widget.seller.phone!, context: context),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service",
                      style: CustomTextStyle.font_15_black,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Styling.primaryColor,
                          radius: 5.r,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          widget.seller.service ?? "Service Null",
                          style: CustomTextStyle.font_14_red,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.w,
                ),
                SendRequestBttnForSpecificSeller(
                  seller: widget.seller,
                  height: 30.h,
                  widht: 95.w,
                  textSize: 13.sp,
                  distance: (distance / 1000)
                      .toString()
                      .substring(0, distance.toString().length ~/ 3),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CallWidget(
                    num: widget.seller.phone!,
                    context: context,
                    radius: 20.r,
                    iconSize: 16.h,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
