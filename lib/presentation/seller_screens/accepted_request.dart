import 'package:e_mech/presentation/seller_screens/shimmer_screen.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/accepted_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../data/firebase_user_repository.dart';
import '../../domain/entities/request_model.dart';
import '../../domain/entities/seller_model.dart';
import '../../providers/seller_provider.dart';
import '../widgets/user_homepage_header.dart';

class AcceptedRequest extends StatefulWidget {
  const AcceptedRequest({super.key});
  @override
  State<AcceptedRequest> createState() => _AcceptedRequestState();
}
class _AcceptedRequestState extends State<AcceptedRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SellerModel? seller =
        Provider.of<SellerProvider>(context, listen: false).seller;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserHomePageHeader(
                name: seller!.name!,
                text: "Accepted Requst",
                imageUrl: seller.profileImage!,
              ),
              SizedBox(
                height: 35.h,
              ),
              StreamBuilder<List<RequestModel>>(
                stream: FirebaseUserRepository.getAcceptedRequests(context),
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
                            child: AcceptedRequestWidget(
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
