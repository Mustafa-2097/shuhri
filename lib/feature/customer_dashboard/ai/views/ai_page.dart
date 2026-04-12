import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F5F9,
      ), // Light grey background from image
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: [
                // Right aligned status chips (User actions)
                _buildUserStatusChip('Job started'),
                _buildUserStatusChip('Job completed'),
                _buildUserStatusChip('Running late'),

                SizedBox(height: 24.h),

                // AI/Admin Response
                _buildAdminResponse(
                  'Got it! Thanks for the update.',
                  '12:16 PM',
                ),

                SizedBox(height: 24.h),

                // Location Card///
                _buildLocationCard(
                  address: '123 Business Park, Flo...',
                  time: '2:11 PM',
                ),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0084E3), // Vibrant blue from image
      elevation: 0,
      // leading: IconButton(
      //   icon: Container(
      //     padding: EdgeInsets.all(6.w),
      //     decoration: BoxDecoration(
      //       color: Colors.white.withOpacity(0.2),
      //       borderRadius: BorderRadius.circular(8.r),
      //     ),
      //     child: const Icon(Icons.arrow_back, color: Colors.white),
      //   ),
      //   onPressed: () => Navigator.pop(context),
      // ),
      title: Text(
        'My Day AI',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserStatusChip(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        width: 180.w, // Fixed width similar to image
        decoration: BoxDecoration(
          color: const Color(0xFF0084E3),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '12:15 PM',
                  style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.done_all, color: Colors.white70, size: 12.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminResponse(String message, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Support',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyle(fontSize: 10.sp, color: Colors.black38),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard({required String address, required String time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(16.w),
        width: 280.w,
        decoration: BoxDecoration(
          color: const Color(0xFF0084E3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Location Shared',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              address,
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF32ADE6),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: const Text('View on Map'),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.done_all, color: Colors.white70, size: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF91C9F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.send_rounded, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../tasks/views/widgets/voice_ui.dart';

// class AIPage extends StatelessWidget {
//   const AIPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildAIHeader(),
//             SizedBox(height: 32.h),
//             _buildSectionTitle('AI Smart Commands'),
//             SizedBox(height: 16.h),
//             _buildFeatureGrid(),
//             SizedBox(height: 32.h),
//             _buildSectionTitle('Today AI Insights'),
//             SizedBox(height: 16.h),
//             _buildAIInsightCard(),
//             SizedBox(height: 100.h), // Space for bottom padding
//           ],
//         ),
//       ),
//       floatingActionButton: _buildAIActionButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Text(
//         'AI Assistant',
//         style: TextStyle(
//           fontSize: 24.sp,
//           fontWeight: FontWeight.w800,
//           color: const Color(0xFF0F172A),
//         ),
//       ),
//       // actions: [
//       //   IconButton(
//       //     onPressed: () {},
//       //     icon: Icon(Icons.settings_outlined, color: const Color(0xFF64748B), size: 24.sp),
//       //   ),
//       //   SizedBox(width: 8.w),
//       // ],
//     );
//   }

//   Widget _buildAIHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(30.r),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2563EB).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.auto_awesome_rounded,
//                   color: Colors.white,
//                   size: 24.sp,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Text(
//                 'AI Engine Active',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white.withOpacity(0.9),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 24.h),
//           Text(
//             'How can I help you\noptimize your day?',
//             style: TextStyle(
//               fontSize: 22.sp,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18.sp,
//         fontWeight: FontWeight.w700,
//         color: const Color(0xFF0F172A),
//       ),
//     );
//   }

//   Widget _buildFeatureGrid() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 16.w,
//       mainAxisSpacing: 16.h,
//       childAspectRatio: 1.1,
//       children: [
//         _buildFeatureCard(
//           icon: Icons.bolt_rounded,
//           title: 'Re-Optimize\nWait Day',
//           bgColor: const Color(0xFFEEF2FF),
//           iconColor: const Color(0xFF2563EB),
//         ),
//         _buildFeatureCard(
//           icon: Icons.mic_rounded,
//           title: 'Voice Task\nCreation',
//           bgColor: const Color(0xFFECFDF5),
//           iconColor: const Color(0xFF10B981),
//           onTap: () => Get.to(() => const VoiceListeningScreen()),
//         ),
//         _buildFeatureCard(
//           icon: Icons.bar_chart_rounded,
//           title: 'Productivity\nAnalysis',
//           bgColor: const Color(0xFFFFF7ED),
//           iconColor: const Color(0xFFF59E0B),
//         ),
//         _buildFeatureCard(
//           icon: Icons.calendar_today_rounded,
//           title: 'Smart\nScheduling',
//           bgColor: const Color(0xFFF5F3FF),
//           iconColor: const Color(0xFF8B5CF6),
//         ),
//       ],
//     );
//   }

//   Widget _buildFeatureCard({
//     required IconData icon,
//     required String title,
//     required Color bgColor,
//     required Color iconColor,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(20.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24.r),
//           border: Border.all(color: const Color(0xFFF1F5F9)),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF0F172A).withOpacity(0.04),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
//               child: Icon(icon, color: iconColor, size: 24.sp),
//             ),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xFF0F172A),
//                 height: 1.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAIInsightCard() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24.r),
//         border: Border.all(color: const Color(0xFFF1F5F9)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFDCFCE7),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.auto_awesome_rounded,
//                   color: const Color(0xFF22C55E),
//                   size: 18.sp,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Productivity Boost',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF0F172A),
//                       ),
//                     ),
//                     Text(
//                       'AI saved 45 minutes for you today!',
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: const Color(0xFF64748B),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           Container(
//             height: 120.h,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Center(
//               child: Icon(
//                 Icons.show_chart_rounded,
//                 color: const Color(0xFF2563EB).withOpacity(0.4),
//                 size: 48.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAIActionButton() {
//     return Container(
//       height: 64.h,
//       width: 240.w,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
//         ),
//         borderRadius: BorderRadius.circular(32.r),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF2563EB).withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 24.sp),
//           SizedBox(width: 12.w),
//           Text(
//             'Ask AI Assistant',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
