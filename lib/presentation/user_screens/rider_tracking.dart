import 'package:e_mech/presentation/seller_screens/shimmer_screen.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/user_accepted_request_widget.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../data/firebase_user_repository.dart';
import '../../domain/entities/request_model.dart';
import '../../domain/entities/user_model.dart';
import '../../providers/user_provider.dart';
import '../widgets/user_homepage_header.dart';

class RiderTracking extends StatefulWidget {
  const RiderTracking({super.key});

  @override
  State<RiderTracking> createState() => _RiderTrackingState();
}

class _RiderTrackingState extends State<RiderTracking> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? seller = Provider.of<UserProvider>(context, listen: false).user;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserHomePageHeader(
                name: seller!.name!,
                text: "All Accepted Request",
                imageUrl: seller.profileImage!,
              ),
              SizedBox(
                height: 35.h,
              ),
              StreamBuilder<List<RequestModel>>(
                stream: FirebaseUserRepository.getAcceptedRequestsForSenderId(
                    utils.currentUserUid, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerScreen();
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/noDataAnimation.json",
                            height: 300.h, width: 300.w),
                        const Text("No Accepted Request")
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserAcceptedRequestWidget(
                              requestModel: snapshot.data![index],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
