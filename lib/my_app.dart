import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constant/app_colors.dart';
import 'core/localization/app_translations.dart';
import 'feature/customer_dashboard/dashboard/dashboard.dart';
import 'feature/splash/view/splash_screen.dart';
import 'core/bindings/app_bindings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 867),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        /// Override system text scaling globally
        final fixedMediaQuery = MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0));
        return MediaQuery(
          data: fixedMediaQuery,
          child: GetMaterialApp(
            initialBinding: AppBindings(),
            debugShowCheckedModeBanner: false,
            translations: AppTranslations(),
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: EasyLoading.init()(context, child),
              );
            },
            theme: ThemeData.light().copyWith(
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.whiteColor,
              textTheme: GoogleFonts.robotoTextTheme(
                ThemeData.light().textTheme,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: AppColors.textColor),
              ),
              iconTheme: const IconThemeData(color: AppColors.primaryColor),
              checkboxTheme: CheckboxThemeData(
                shape: const CircleBorder(),
                side: BorderSide(width: 1.5, color: AppColors.boxTextColor),
              ),
            ),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
