import 'package:flutter/material.dart';
import 'package:shuhri/feature/customer_dashboard/dashboard/widgets/bottom_nav.dart';
import '../home/views/home_page.dart';
import '../../profile/view/profile_page.dart';

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
    const SizedBox(),
    const SizedBox(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // set initial tab
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
