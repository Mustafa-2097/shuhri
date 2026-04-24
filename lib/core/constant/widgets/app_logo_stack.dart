import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../image_path.dart';

class AppLogoStack extends StatelessWidget {
  final double? size;

  const AppLogoStack({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final double boxSize = size ?? 100.w;
    final double badgeSize = boxSize * .95;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// ── Calendar icon ─────────────────────────────────────────
          Image.asset(
            ImagePath.splash01,
            width: boxSize,
            height: boxSize,
            fit: BoxFit.contain,
          ),

          /// ── Sparkle / AI badge (top-right) ────────────────────────
          Positioned(
            top: -boxSize * 0.15,
            right: -boxSize * 0.25,
            child: Image.asset(
              ImagePath.splash02,
              width: badgeSize,
              height: badgeSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
