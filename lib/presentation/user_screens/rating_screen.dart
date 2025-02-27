import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/domain/entities/seller_model.dart';
import 'package:e_mech/navigation_page.dart';
import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:velocity_x/velocity_x.dart';

// class Slide {
//   String title;
//   String description;
//   String imageUrl;
//   Widget rate;
//   Widget submitButton;
//   Slide({
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.rate,
//     required this.submitButton,
//   });
// }

// TODO: Code refactor + Redesign

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key, required this.request}) : super(key: key);

  final RequestModel request;

  static const String routeName = '/rating-scren';

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  SellerModel? currentUser;
  bool _isSaving = false;
  final feedbackController = TextEditingController();
  double rating = 2.5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade50,
        // backgroundColor: Theme.of(context).backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text('Rate Service'),
        //   centerTitle: true,
        //   automaticallyImplyLeading: false,
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.close,
        //       color: Colors.white,
        //     ),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rating; i++)
                              Icon(
                                Icons.star,
                                size: 40,
                                color: Styling.primaryColor,
                              )
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationPage()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          4.widthBox,
                          'CLOSE'
                              .text
                              .letterSpacing(2)
                              .color(Colors.grey)
                              .size(18)
                              .make(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 20,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 32,
                                ),
                                child: Column(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(text: 'Your valuable '),
                                          TextSpan(
                                            text: 'feedback',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Styling.primaryColor,
                                            ),
                                          ),
                                          TextSpan(text: ' matters!')
                                        ],
                                      ),
                                    ),
                                    8.heightBox,
                                    'Please rate the service you received from this user!'
                                        .text
                                        .center
                                        .color(Colors.grey)
                                        .size(14)
                                        .makeCentered(),
                                    16.heightBox,
                                    RatingBar(
                                      ratingWidget: RatingWidget(
                                        full: Icon(
                                          Icons.star_rate_rounded,
                                          color: Colors.amber.shade600,
                                        ),
                                        half: Icon(
                                          Icons.star_half_rounded,
                                          color: Colors.amber.shade600,
                                        ),
                                        empty: Icon(
                                          Icons.star_border_rounded,
                                          color: Colors.amber.shade600,
                                        ),
                                      ),
                                      onRatingUpdate: (d) {
                                        setState(() {
                                          rating = d;
                                        });
                                      },
                                    ),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.grey.shade300,
                                    //     borderRadius: BorderRadius.circular(5),
                                    //   ),
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 8.0),
                                    //   child: TextField(
                                    //     controller: feedbackController,
                                    //     decoration: InputDecoration(
                                    //       hintText:
                                    //           'Please enter your feedback here, we try to read and understand your concerns all the time :)',
                                    //       hintStyle: TextStyle(
                                    //         color: Colors.grey,
                                    //       ),
                                    //       border: InputBorder.none,
                                    //     ),
                                    //     maxLines: 4,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          32.heightBox,
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  backgroundColor: Styling.primaryColor),
                              onPressed: () {
                                setState(() {
                                  _isSaving = false;
                                });
                                FirebaseUserRepository
                                    .addRatingToMechanicProfile(
                                        widget.request, rating, context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationPage()));
                              },
                              child: Text('SUBMIT FEEDBACK')
                                  .text
                                  .white
                                  .letterSpacing(1.5)
                                  .size(16)
                                  .make()
                                  .p8(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
