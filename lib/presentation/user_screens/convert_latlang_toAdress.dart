import 'package:e_mech/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatLangAddress extends StatefulWidget {
  const ConvertLatLangAddress({super.key});

  @override
  State<ConvertLatLangAddress> createState() => _ConvertLatLangAddressState();
}

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.street}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      return address;
    }
  } catch (e) {
    utils.toastMessage(e.toString());
  }

  return '';
}

class _ConvertLatLangAddressState extends State<ConvertLatLangAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              getAddressFromLatLng(24.965508, 69.293713);
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.black,
              child: const Text("convert"),
            ),
          ),
        ],
      ),
    );
  }
}
