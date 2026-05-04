import 'package:flutter/material.dart';
import 'package:shukriraad/feature/customer_dashboard/ai/views/ai_page.dart';
import 'package:shukriraad/feature/customer_dashboard/dashboard/widgets/bottom_nav.dart';
import '../home/views/home_page.dart';
import '../tasks/views/task_list_page.dart';
import '../ai/views/ai_page.dart';
import '../../profile/view/profile_page.dart';

import '../home/controllers/home_controller.dart';
import '../tasks/controllers/task_controller.dart';
import 'package:get/get.dart';

class CustomerDashboard extends StatefulWidget {
  final int initialIndex;
  const CustomerDashboard({super.key, this.initialIndex = 0});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    HomePage(),
    TaskListPage(),
    AIPage(),
    const ProfilePage(showBackButton: false),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchTodayOverview();
      }
      if (Get.isRegistered<TaskController>()) {
        Get.find<TaskController>().fetchTasks();
      }
    } else if (index == 1) {
      if (Get.isRegistered<TaskController>()) {
        Get.find<TaskController>().fetchTasks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
