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
      width: boxSize + badgeSize * 0.5, // extra room so badge isn't clipped
      height: boxSize + badgeSize * 0.25,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// ── Calendar icon ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              ImagePath.splash01,
              width: boxSize,
              fit: BoxFit.contain,
            ),
          ),

          /// ── Sparkle / AI badge (top-right) ────────────────────────
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              ImagePath.splash02,
              width: badgeSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
