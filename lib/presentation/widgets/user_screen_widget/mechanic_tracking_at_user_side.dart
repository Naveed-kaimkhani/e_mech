import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/presentation/seller_screens/SellerSideChatScreen.dart';
import 'package:e_mech/presentation/seller_screens/tracing_screen_bottonnavigation.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/loading_map.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/seller_model.dart';

class MechanicTrackingAtUserSide extends StatefulWidget {
  final RequestModel requestModel;
  const MechanicTrackingAtUserSide({super.key, required this.requestModel});

  @override
  State<MechanicTrackingAtUserSide> createState() =>
      _MechanicTrackingAtUserSideState();
}

class _MechanicTrackingAtUserSideState
    extends State<MechanicTrackingAtUserSide> {
  // List<SellerModel>? _listOfSellers;
  final CustomInfoWindowController _windowinfoController =
      CustomInfoWindowController();
  final String apiKey = 'AIzaSyD6sruWDaBsYEfYdMDCuEwTvq_5Mk5bK7o';
  LatLng? sourceLocation = const LatLng(0.0, 0.0);
  LatLng? riderLocation;
  SellerModel? seller;
  Uint8List? sellerTracingIcon;

  // Uint8List? sellerLocation;
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polyLineCoordinates = [];
  Position? currentLocation;
  // StreamSubscription<Position>? positionStreamSubscription;
  double? distance;

  double getDistancebtwRiderNSeller(
    double riderLat,
    double riderLong,
  ) {
    return Geolocator.distanceBetween(riderLat, riderLong,
        widget.requestModel.senderLat!, widget.requestModel.senderLong!);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin: PointLatLng(
              widget.requestModel.senderLat!, widget.requestModel.senderLong!),
          destination:
              PointLatLng(riderLocation!.latitude, riderLocation!.longitude),
          mode: TravelMode.driving,

          // PointLatLng(25.5238, 69.0141),
        ));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
    addMarker();
  }

  Future<Uint8List> getByteFromAssets(String path, int widht) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: widht);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  addMarker() async {
    sellerTracingIcon = await getByteFromAssets("assets/man.png", 100);
    // sellerLocation = await getByteFromAssets("assets/SellerLocation.png", 70);
  }

// Initialize Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Start listening to rider location updates
  void listenToRiderLocation() async {
    print("listenToRiderLocation");
    await firestore
        .collection('sellers')
        .doc(widget.requestModel.receiverUid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        // Handle rider's location update
        double latitude = snapshot['lat'];
        double longitude = snapshot['long'];
        setState(() {
          riderLocation = LatLng(latitude, longitude);

          distance = getDistancebtwRiderNSeller(
              riderLocation!.latitude, riderLocation!.longitude);
        });
        // Update the rider's location on the map or do other processing as needed
      }
      getPolyPoints();
    });
    if (riderLocation != null) {
      getPolyPoints();
    }
  }

  @override
  void dispose() {
    // positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    utils.checkConnectivity(context);
    sourceLocation =
        LatLng(widget.requestModel.senderLat!, widget.requestModel.senderLong!);
    // seller = Provider.of<SellerProvider>(context, listen: false).seller;
    // _listOfSellers =
    //     Provider.of<AllSellerDataProvider>(context, listen: false).sellers;
    addMarker();
    listenToRiderLocation();
    // initializeValues();

    // getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    String dis = distance.toString();
    double halfLength =
        dis.length / 3; // Calculate the half length of the string
    double firstLine = (widget.requestModel.senderAddress!.length / 2);
    return SafeArea(
      child: riderLocation == null &&
              sellerTracingIcon == null &&
              distance == null
          ? const LoadingMap()
          : Scaffold(
              bottomNavigationBar: TracingScreenBottomNavigation(
                distance: distance,
                halfLength: halfLength,
                // senderAddress: widget.requestModel.senderAddress,
                senderPhone: widget.requestModel.senderPhone,
                firstLine: firstLine,
                text: "Calll Mechanic",
              ),
              floatingActionButton: IconButton(
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
                iconSize: 40.h,
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(sourceLocation!.latitude,
                            sourceLocation!.longitude),
                        zoom: 18),
                    compassEnabled: true,
                    markers: {
                      Marker(
                          markerId: const MarkerId(
                            "0",
                          ),
                          position: LatLng(sourceLocation!.latitude,
                              sourceLocation!.longitude),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: const InfoWindow(title: "Your Position")),
                      Marker(
                        markerId: const MarkerId("1"),
                        position: riderLocation!,
                        icon: sellerTracingIcon == null
                            ? BitmapDescriptor.defaultMarker
                            : BitmapDescriptor.fromBytes(sellerTracingIcon!),
                        onTap: () {
                          // _windowinfoController.addInfoWindow!(
                          //   UserMarkerInfoWindow(
                          //     request: widget.requestModel,
                          //   ),
                          //   LatLng(widget.requestModel.senderLat!,
                          //       widget.requestModel.senderLong!),
                          // );
                        },
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _windowinfoController.googleMapController = controller;
                    },
                    onTap: (position) {
                      _windowinfoController.hideInfoWindow!();
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polyLineCoordinates,
                        color: Styling.primaryColor,
                        width: 6,
                      )
                    },
                  ),
                  const BackButton(),
                  CustomInfoWindow(
                    controller: _windowinfoController,
                    height: 150,
                    width: 300,
                    offset: 10,
                  ),
                ],
              ),
            ),
    );
  }
}
