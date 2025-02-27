// import 'dart:async';

// import 'package:e_mech/data/firebase_user_repository.dart';
// import 'package:e_mech/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GetUserCurrentLocation extends StatefulWidget {
//   const GetUserCurrentLocation({super.key});

//   @override
//   State<GetUserCurrentLocation> createState() => _GetUserCurrentLocationState();
// }

// class _GetUserCurrentLocationState extends State<GetUserCurrentLocation> {
//   FirebaseUserRepository _firebaseUserRepository = FirebaseUserRepository();
//   final Completer<GoogleMapController> _controller = Completer();
//   double lat = 24.965508;
//   // CameraPosition? _cameraPosition;
//   static CameraPosition _cameraPosition = CameraPosition(
//     target: LatLng(24.965508, 69.293713),
//     zoom: 14.4746,
//   );
//   // List<Marker> _marker = [];
//   final List<Marker> _marker = [
//     // const Marker(
//     //     markerId: MarkerId('1'),
//     //     position: LatLng(24.965508, 69.293713),
//     //     infoWindow: InfoWindow(title: "My Position"))
//   ];
//   //   Future<Position> getUserCurrentLocation() async{
//   //     await Geolocator.requestPermission().then((value){

//   //     }).onError((error, stackTrace) {
//   //       print(error);
//   //     });
//   // return await Geolocator.getCurrentPosition();
//   //   }


//   Future<Position?> getUserCurrentLocation() async {
//     try {
//       print("in getUserCurrent lcoation");
//       await Geolocator.requestPermission();
//       return await Geolocator.getCurrentPosition();
//     } catch (error) {
//       // print(error);
//       utils.flushBarErrorMessage(error.toString(), context);
//       // Handle the error as needed
//       return null; // or throw the error
//     }
//   }

//   loadLocation() {
//     getUserCurrentLocation().then((value) async {
//       String adress =
//           await utils.getAddressFromLatLng(value!.latitude, value.longitude,context);
//       await _firebaseUserRepository.addlatLongToUserDocument(
//           value.latitude, value.longitude, adress, context);
//       _marker.add(Marker(
//           position: LatLng(value.latitude, value.longitude),
//           markerId: MarkerId('1'),
//           infoWindow: InfoWindow(title: "My Position")));
//       setState(() {
//         _cameraPosition = CameraPosition(
//           target: LatLng(value.latitude, value.longitude),
//           // zoom: 14.4746,
//           zoom: 18,
//         );
//       });

//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
//     });
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.location_searching_outlined),
//           onPressed: () async {
//             final GoogleMapController controller = await _controller.future;
//             controller
//                 .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
//           }),
//       body: GoogleMap(
//         initialCameraPosition: _cameraPosition,
//         compassEnabled: true,
//         markers: Set<Marker>.of(_marker),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }
