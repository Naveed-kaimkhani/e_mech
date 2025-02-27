import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.url,
    required this.height,
    required this.width,
  });

  final String? url;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(45.r)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: CircularProgressIndicator(
          value: progress.progress,
        ),
      ),
      imageUrl: url ??
          'https://media.istockphoto.com/id/1268548918/vector/white-create-account-screen-icon-isolated-with-long-shadow-red-circle-button-vector.jpg?s=612x612&w=0&k=20&c=tyaWWtW2_yQyvK4hBnVXEt3tfSNr0jVC_6P7XbOBrbk=',
    );
  }
}
