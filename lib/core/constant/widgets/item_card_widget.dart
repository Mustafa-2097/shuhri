import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';

class ItemCardWidget extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  final int quantity;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool showQuantityControls;

  const ItemCardWidget({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
    this.showQuantityControls = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1CF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40.w,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (onDelete != null)
                  Positioned(
                    top: 14.h,
                    right: 14.w,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: AppColors.redColor,
                          size: 16.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.boxTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E61E6),
                      ),
                    ),
                    if (showQuantityControls)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onDecrease,
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.redColor,
                              size: 18.w,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            quantity.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: onIncrease,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: const Color(0xFF1B4E9B),
                              size: 18.w,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
