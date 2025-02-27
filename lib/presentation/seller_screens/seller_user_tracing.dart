import 'dart:async';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/domain/entities/request_model.dart';
import 'package:e_mech/presentation/seller_screens/SellerSideChatScreen.dart';
import 'package:e_mech/presentation/seller_screens/seller_navigation.dart';
import 'package:e_mech/presentation/seller_screens/tracing_screen_bottonnavigation.dart';
import 'package:e_mech/presentation/widgets/seller_screen_widget/ride_cancel_popup.dart';
import 'package:e_mech/presentation/widgets/user_screen_widget/loading_map.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/seller_model.dart';
import '../../providers/all_sellerdata_provider.dart';
import '../../providers/seller_provider.dart';
import '../widgets/seller_screen_widget/user_marker_infowindow.dart';

class SellerUserTracing extends StatefulWidget {
  final RequestModel requestModel;
  const SellerUserTracing({super.key, required this.requestModel});

  @override
  State<SellerUserTracing> createState() => _SellerUserTracingState();
}

class _SellerUserTracingState extends State<SellerUserTracing> {
  List<SellerModel>? _listOfSellers;
  final CustomInfoWindowController _windowinfoController =
      CustomInfoWindowController();
  final String apiKey = 'AIzaSyD6sruWDaBsYEfYdMDCuEwTvq_5Mk5bK7o';
  LatLng? sourceLocation = const LatLng(0.0, 0.0);
  LatLng? destinationLocation;
  SellerModel? seller;
  Uint8List? sellerTracingIcon;

  Uint8List? sellerLocation;
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polyLineCoordinates = [];
  Position? currentLocation;
  StreamSubscription<Position>? positionStreamSubscription;
  double? distance;

  double getDistancebtwRiderNSeller(
    double riderLat,
    double riderLong,
  ) {
    return Geolocator.distanceBetween(riderLat, riderLong,
        destinationLocation!.latitude, destinationLocation!.longitude);
  }

  void getUserCurrentLocation() async {
    try {
      currentLocation = await convertLatLngToPosition(
          LatLng(sourceLocation!.latitude, sourceLocation!.longitude));
      positionStreamSubscription = Geolocator.getPositionStream().listen(
        (Position position) async {
          GoogleMapController controller = await _controller.future;
          await FirebaseUserRepository.updateRiderLocation(
              position.latitude, position.longitude, utils.currentUserUid);
          setState(() {
            currentLocation = position;

            distance = getDistancebtwRiderNSeller(
                position.latitude, position.longitude);
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  zoom: 18,
                ),
              ),
            );
          });
        },
        onError: (e) {
          utils.flushBarErrorMessage(e.toString(), context);
        },
      );
    } catch (error) {
      utils.flushBarErrorMessage(error.toString(), context);
      return null; // or throw the error
    }
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin:
              PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
          destination: PointLatLng(
              destinationLocation!.latitude, destinationLocation!.longitude),
          mode: TravelMode.driving,
        ));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
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

  Future<Position> convertLatLngToPosition(LatLng latLng) async {
    return Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
      isMocked: false,
      floor: null,
    );
  }

  addMarker() async {
    sellerTracingIcon = await getByteFromAssets("assets/man.png", 100);
    sellerLocation = await getByteFromAssets("assets/SellerLocation.png", 70);
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void startRideTimer() {
    Timer(Duration(minutes: 5), () async {
      // Timer expired, cancel the ride and assign to another rider
      int initialDistance = getDistancebtwRiderNSeller(
              sourceLocation!.latitude, sourceLocation!.longitude)
          .toInt();
      int currentDistance = getDistancebtwRiderNSeller(
              currentLocation!.latitude, currentLocation!.longitude)
          .toInt();
      // double CalculatedDistance=currentDistance-initialDistance;

      if (currentDistance > initialDistance) {
        // showLogoutPopup(context);
      } else {
        cancelAndReassignRequest();
      }
    });
  }

  cancelAndReassignRequest() async {
    await FirebaseUserRepository.sentRequest(
        _listOfSellers!, widget.requestModel, context);
    // ignore: use_build_context_synchronously
    await FirebaseUserRepository.deleteRequestDocument(
        "AcceptedRequest", widget.requestModel.documentId!, context);
    // ignore: use_build_context_synchronously
    showRideCancelPopup(
        "Ride has been canceled", "You are not reaching to user", context);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SellerNavigation()));
  }

  @override
  void initState() {
    super.initState();

    utils.checkConnectivity(context);

    seller = Provider.of<SellerProvider>(context, listen: false).seller;
    _listOfSellers =
        Provider.of<AllSellerDataProvider>(context, listen: false).sellers;

    sourceLocation = LatLng(seller!.lat!, seller!.long!);
    destinationLocation =
        LatLng(widget.requestModel.senderLat!, widget.requestModel.senderLong!);
    distance = getDistancebtwRiderNSeller(
        sourceLocation!.latitude, sourceLocation!.longitude);
    addMarker();
    getPolyPoints();
    getUserCurrentLocation();
    startRideTimer();
  }

  @override
  Widget build(BuildContext context) {
    String dis = distance.toString();
    double halfLength =
        dis.length / 3; // Calculate the half length of the string
    double firstLine = (widget.requestModel.senderAddress!.length / 2);
    return SafeArea(
      child: currentLocation == null
          ? const LoadingMap()
          : Scaffold(
              bottomNavigationBar: TracingScreenBottomNavigation(
                distance: distance,
                halfLength: halfLength,
                senderAddress: widget.requestModel.senderAddress!,
                senderPhone: widget.requestModel.senderPhone!,
                firstLine: firstLine,
                text: "Call User",
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
                        target: LatLng(currentLocation!.latitude,
                            currentLocation!.longitude),
                        zoom: 18),
                    compassEnabled: true,
                    markers: {
                      Marker(
                          markerId: const MarkerId(
                            "0",
                          ),
                          position: LatLng(currentLocation!.latitude,
                              currentLocation!.longitude),
                          icon: BitmapDescriptor.fromBytes(sellerTracingIcon!),
                          infoWindow:
                              const InfoWindow(title: "Current Position")),
                      Marker(
                          markerId: const MarkerId("1"),
                          position: LatLng(sourceLocation!.latitude,
                              sourceLocation!.longitude),
                          icon: BitmapDescriptor.fromBytes(sellerLocation!),
                          infoWindow: const InfoWindow(title: "Your Position")),
                      Marker(
                        markerId: const MarkerId("2"),
                        position: destinationLocation!,
                        icon: BitmapDescriptor.defaultMarker,
                        onTap: () {
                          _windowinfoController.addInfoWindow!(
                            UserMarkerInfoWindow(
                              request: widget.requestModel,
                            ),
                            LatLng(widget.requestModel.senderLat!,
                                widget.requestModel.senderLong!),
                          );
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
