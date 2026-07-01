import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/membership_model.dart';
import 'package:gymklout/providers/membership_provider.dart';

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
    return Padding(
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
    );
  }
}
