import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/presentation/seller_screens/shimmer_screen.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/no_data_found_screen.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/specific_serviceprovider_widget.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/specific_services_provider_header.dart';
import 'package:e_mech/style/images.dart';
import 'package:flutter/material.dart';

class PunctureMaker extends StatelessWidget {
  const PunctureMaker({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpecificServicesProviderHeader(
              text: "Puncture Makers",
              imageUrl: Images.wheel,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.7, // Set an appropriate height
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    FirebaseUserRepository.getSellersBasedOnService("Puncture"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: ShimmerScreen(),
                    );
                  } else if (snapshot.hasData && snapshot.data!.length == 0) {
                    return const Center(
                      child: NoDataFoundScreen(
                        text: "No Puncture Maker Available",
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        SellerModel seller =
                            SellerModel.fromMap(snapshot.data![index]);

                        return SpecificServiceProviderWidget(seller: seller);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error occurred"),
                    );
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
