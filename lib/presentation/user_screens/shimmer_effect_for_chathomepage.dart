import 'package:flutter/material.dart';
import '../widgets/seller_screen_widget/shimmer_effect.dart';
class ShimmerEffectForChatHomePage extends StatelessWidget {
  const ShimmerEffectForChatHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      height: MediaQuery.of(context).size.height,
       child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(
                color: Colors.white,
                thickness: 10,
                indent: 20,
                endIndent: 20,
              ),
          itemCount: 4, // Show the shimmer effect 5 times
          itemBuilder: (context, index) => ShimmerEffect()),
    );
  }
}
