import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/membership_model.dart';
import 'package:gymklout/providers/membership_provider.dart';
import 'package:gymklout/screens/home/widgets/header.dart';

class HomeMembershipWidget extends StatefulWidget {
  final MembershipModel membership;
  final MembershipSessionStatus status;
  
  const HomeMembershipWidget({super.key, required this.membership, required this.status});

  @override
  State<HomeMembershipWidget> createState() =>
      _NoGymMembershipHomeScreenState();
}

class _NoGymMembershipHomeScreenState extends State<HomeMembershipWidget> {
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
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
