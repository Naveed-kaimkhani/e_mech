import 'package:e_mech/presentation/seller_screens/shimmer_screen.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../data/firebase_user_repository.dart';
import '../../domain/entities/request_model.dart';
import '../../domain/entities/seller_model.dart';
import '../../providers/seller_provider.dart';
import '../widgets/seller_screen_widget/no_data_found_screen.dart';
import '../widgets/user_homepage_header.dart';

class SellerHomepage extends StatefulWidget {
  const SellerHomepage({super.key});

  @override
  State<SellerHomepage> createState() => _SellerHomepageState();
}

class _SellerHomepageState extends State<SellerHomepage> {
// this function fill be used when the seller location is need to update everytime he open the app
  loadSellerData() async {
    await Provider.of<SellerProvider>(context, listen: false)
        .getSellerFromServer(context);
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
                text: "All Request",
                imageUrl: seller.profileImage!,
              ),
              SizedBox(
                height: 35.h,
              ),
              StreamBuilder<List<RequestModel>>(
                stream: FirebaseUserRepository.getRequests(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerScreen();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const NoDataFoundScreen(
                      text: "No pending request",
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RequestWidget(
                            requestModel: snapshot.data![index],
                          ),
                        );
                      },
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
