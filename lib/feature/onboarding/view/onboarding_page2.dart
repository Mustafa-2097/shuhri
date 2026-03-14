import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';

/// Onboarding Page 2 — "Add tasks. We optimize."
class OnboardingPage2 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage2({super.key, required this.onNext});

  static const _features = [
    _FeatureItem(icon: Icons.mic_rounded, label: 'Text or Voice Input'),
    _FeatureItem(icon: Icons.schedule_rounded, label: 'Smart Scheduling'),
    _FeatureItem(icon: Icons.check_circle_outline_rounded, label: 'Smart Reminders'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          /// ── Title ───────────────────────────────────────────────
          Text(
            'Add tasks.\nWe optimize.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0D1B2A),
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),

          SizedBox(height: 36.h),

          /// ── Feature rows ────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D85F2).withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_features.length, (i) {
                return Column(
                  children: [
                    _FeatureRow(item: _features[i]),
                    if (i < _features.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: const Color(0xFFF0F4FB),
                        indent: 20.w,
                        endIndent: 20.w,
                      ),
                  ],
                );
              }),
            ),
          ),

          const Spacer(flex: 3),

          /// ── Button ──────────────────────────────────────────────
          _OnboardingButton(label: 'Continue', onTap: onNext),

          SizedBox(height: 36.h),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;
  const _FeatureItem({required this.icon, required this.label});
}

class _FeatureRow extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          /// Icon box
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(item.icon, color: Colors.white, size: 22.sp),
          ),

          SizedBox(width: 16.w),

          /// Label
          Text(
            item.label,
            style: TextStyle(
              color: const Color(0xFF0D1B2A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill-shaped CTA button — same gradient style as Page 1.
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
