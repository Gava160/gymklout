import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/club-partner/my_club_partner.dart';
import 'package:gymklout/screens/find-gym-center/find_gym_center.dart';
import 'package:gymklout/screens/home/home_screen.dart';
import 'package:gymklout/screens/my-account/my_account.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBarController extends ConsumerStatefulWidget {
  const BottomNavBarController({super.key});

  @override
  ConsumerState<BottomNavBarController> createState() =>
      _BottomNavBarControllerState();
}

class _BottomNavBarControllerState
    extends ConsumerState<BottomNavBarController> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      extendBody: true,
      body: activePages[_selectedScreen],
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(right: 25, bottom: 25, left: 25, top: 5),
              child: GNav(
                gap: 8,
                backgroundColor: Colors.transparent,
                color: isDark ? AppDefaults.white : AppDefaults.black,
                activeColor: AppDefaults.white,
                tabBackgroundColor: AppDefaults.primaryColor.withAlpha(150),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                onTabChange: (index) => _selectNavBar(index),
                tabs: [
                  GButton(icon: Iconsax.home, text: "Home"),
                  GButton(
                    icon: Icons.abc,
                    text: "Search",
                    leading: FaIcon(FontAwesomeIcons.dumbbell, size: 20),
                  ),
                  GButton(icon: Iconsax.map, text: "Map"),
                  GButton(
                    icon: Iconsax.user,
                    text: "My Account",
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: profile?.avatarUrl == null
                            ? DecorationImage(
                                image: AssetImage(AppMedia.avatar),
                                fit: BoxFit.cover,
                              )
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: profile?.avatarUrl != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profile?.avatarUrl ?? "",
                                cacheKey: profile?.avatarUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppDefaults.textColor
                                      .withAlpha(20),
                                  child: const Icon(Icons.person, size: 24),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: AppDefaults.textColor
                                          .withAlpha(20),
                                      child: const Icon(Icons.person, size: 24),
                                    ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
