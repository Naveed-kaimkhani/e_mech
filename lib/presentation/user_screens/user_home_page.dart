import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/location.dart';
import 'package:e_mech/providers/all_sellerdata_provider.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/seller_info_window.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/send_request_dialogue.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/seller_model.dart';
import '../../domain/entities/user_model.dart';
import '../../style/images.dart';
import '../../providers/user_provider.dart';
import '../widgets/general_bttn_for_userhmpg.dart';
import '../widgets/user_homepage_header.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final CustomInfoWindowController _windowinfoController =
      CustomInfoWindowController();
  List<SellerModel>? _sellerModel;
  UserModel? user;
  bool isLoadingNow = false;

  static CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(24.965508, 69.293713),
    // target: LatLng(currentPositon, longitude),
    zoom: 18,
  );

  List<Marker> _marker = [];

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  loadLocation() async {
    try {
      user = Provider.of<UserProvider>(context, listen: false).user;
      _sellerModel =
          Provider.of<AllSellerDataProvider>(context, listen: false).sellers;

      addMarker(user!.lat!, user!.long!, '1', 'My Position 1');

      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(user!.lat!, user!.long!),
          zoom: 18,
        );
        animateCamera();
      });
    } catch (error)
     {
      print(error);
      // utils.flushBarErrorMessage(error.toString(), context);
    }
  }

  void addMarker(double lat, double long, String markerId, String title) {
    _marker.add(Marker(
      position: LatLng(lat, long),
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: title),
    ));
  }

  Future<void> animateCamera() async {
    GoogleMapController controller = await _controller.future;
 setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
 });
  }

  Future<Uint8List> getByteFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void createSellersMarkers() async {
    final Uint8List icon = await getByteFromAssets(Images.mech, 80);
    _marker = _sellerModel!.map((seller) {
      final markerId = MarkerId(seller.name!);
      final marker = Marker(
        markerId: markerId,
        position: LatLng(seller.lat!, seller.long!),
        anchor: const Offset(0.5, 0.0),
        icon: BitmapDescriptor.fromBytes(icon),
        onTap: () {
          _windowinfoController.addInfoWindow!(
            SellerInfoWindow(seller: seller,userLat:user!.lat! ,userLong: user!.long!,),
            LatLng(seller.lat!, seller.long!),
          );
        },
      );
      return marker;
    }).toList();

    _marker.add(Marker(
      position: LatLng(user!.lat!, user!.long!),
      markerId: MarkerId(user!.name!),
      infoWindow: const InfoWindow(title: "Your Position"),
    ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    utils.checkConnectivity(context);
    loadLocation();
    createSellersMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            callButton(),
            SizedBox(height: 20.h),
            // locationButton(),
            Locationbttn(func: animateCamera),
            SizedBox(height: 20.h),
            InkWell(
              child: GeneralBttnForUserHmPg(
                text: "Hire Now",
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SendRequestDialogue();
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _cameraPosition,
              compassEnabled: true,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _windowinfoController.googleMapController = controller;
              },
              onTap: (position) {
                _windowinfoController.hideInfoWindow!();
              },
            ),
            CustomInfoWindow(
              controller: _windowinfoController,
              height: 150,
              width: 300,
              offset: 10,
            ),
            UserHomePageHeader(
              name: user!.name!,
              imageUrl: user!.profileImage!,
              text: "Find Mechanic Now",
            ),
          ],
        ),
      ),
    );
  }

  Padding locationButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0),
      child: FloatingActionButton(
        backgroundColor: Styling.primaryColor,
        heroTag: "btn2",
        child: const Icon(
          Icons.location_searching_outlined,
          color: Colors.white,
        ),
        onPressed: () async {
          animateCamera();
        },
      ),
    );
  }

  Padding callButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0),
      child: FloatingActionButton(
        backgroundColor: Styling.primaryColor,
        heroTag: "btn1",
        child: const Icon(
          Icons.call,
          color: Colors.white,
        ),
        onPressed: () {
          utils.launchphone('03103443527', context);
        },
      ),
    );
  }
}
