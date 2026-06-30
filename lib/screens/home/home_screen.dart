import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/home/sections/recommended_gyms_section.dart';
import 'package:gymklout/screens/home/widgets/header.dart';
import 'package:gymklout/screens/home/widgets/no_gym_membership.dart';
import 'package:gymklout/screens/home/widgets/reuseable_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: SafeArea(child: Header()),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppDefaults.defaultPadding,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NoGymMembershipWidget(
                  title: "Find Gym Membership",
                  desc:
                      "You need a gym membership to unlock all the features of ${AppDefaults.appName}",
                  onClick: () {},
                ),
                SizedBox(height: 20),
                ReuseableBlockHeader(
                  title: "Recommended for you",
                  actionText: "",
                ),
                const RecommendedGymsSection(maxItems: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
