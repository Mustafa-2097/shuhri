import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/widgets/app_logo_stack.dart';

/// Onboarding Page 1 — "Plan smarter. Not harder."
class OnboardingPage1 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          /// ── Hero logo (shared with splash) ──────────────────────
          AppLogoStack(size: 110.w),

          const Spacer(flex: 2),

          /// ── Title ───────────────────────────────────────────────
          Text(
            'Plan smarter.\nNot harder.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0D1B2A),
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),

          SizedBox(height: 14.h),

          /// ── Subtitle ─────────────────────────────────────────────
          Text(
            'Let AI organize your day automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8A9BB0),
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),

          const Spacer(flex: 3),

          /// ── Button ──────────────────────────────────────────────
          _OnboardingButton(label: 'Get Started', onTap: onNext),

          SizedBox(height: 36.h),
        ],
      ),
    );
  }
}

/// Pill-shaped CTA button used on both onboarding pages.
class _OnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OnboardingButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D85F2), Color(0xFF1A6FD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
