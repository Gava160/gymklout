import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/club-partner/my_club_partner.dart';
import 'package:gymklout/screens/find-club/find_gym_center.dart';
import 'package:gymklout/screens/home/home_screen.dart';
import 'package:gymklout/screens/my-account/my_account.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBarController extends StatefulWidget {
  const BottomNavBarController({super.key});

  @override
  State<BottomNavBarController> createState() => _BottomNavBarControllerState();
}

class _BottomNavBarControllerState extends State<BottomNavBarController> {
  final List<Widget> activePages = [
    HomeScreen(),
    FindGymCenterScreen(),
    MyClubPartnerScreen(),
    MyAccountScreen(),
  ];

  int _selectedScreen = 0;
  void _selectNavBar(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: activePages[_selectedScreen],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: GNav(
            gap: 8,
            backgroundColor: Colors.transparent,
            color: AppDefaults.white,
            activeColor: AppDefaults.white,
            tabBackgroundColor: AppDefaults.primaryColor.withAlpha(150),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            onTabChange: (index) => _selectNavBar(index),
            tabs: const [
              GButton(icon: Iconsax.home, text: "Home"),
              GButton(icon: Iconsax.search_normal_1, text: "Search"),
              GButton(icon: Iconsax.map, text: "Map"),
              GButton(icon: Iconsax.user, text: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}
