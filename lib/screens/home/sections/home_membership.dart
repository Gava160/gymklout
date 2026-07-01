import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/membership_model.dart';
import 'package:gymklout/providers/membership_provider.dart';

class HomeMembershipWidget extends ConsumerStatefulWidget {
  final MembershipModel membership;
  final MembershipSessionStatus status;

  const HomeMembershipWidget({
    super.key,
    required this.membership,
    required this.status,
  });

  @override
  ConsumerState<HomeMembershipWidget> createState() =>
      _NoGymMembershipHomeScreenState();
}

class _NoGymMembershipHomeScreenState
    extends ConsumerState<HomeMembershipWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: AppDefaults.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Gym Membership",
                    style: AppDefaults.headLiner1(context)
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You have an active gym membership with ${widget.membership.gym?.name }.",
                    style: AppDefaults.headLiner1(context),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Membership Status: ${widget.status.name}",
                    style: AppDefaults.headLiner1(context)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
