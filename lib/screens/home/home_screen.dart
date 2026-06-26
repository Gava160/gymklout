import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/home/widgets/header.dart';
import 'package:gymklout/screens/home/widgets/no_gym_membership.dart';
import 'package:gymklout/screens/home/widgets/recommended_gymcenter_widget.dart';
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
      body: Padding(
        padding: AppDefaults.defaultPadding,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(),
                SizedBox(height: 20),
                NoGymMembershipWidget(),
                SizedBox(height: 20),
                ReuseableBlockHeader(
                  title: "Recommended clubs for you",
                  actionText: "",
                ),
                RecommendedGymCenters(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
