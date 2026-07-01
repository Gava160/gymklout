import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/providers/membership_provider.dart';
import 'package:gymklout/screens/home/sections/home_membership.dart';
import 'package:gymklout/screens/home/sections/no_gym_membership.dart';
import 'package:gymklout/screens/home/widgets/header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final membershipAsync = ref.watch(activeMembershipProvider);

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
      body: membershipAsync.when(
        loading: () => Center(child: showSpinner()),
        error: (e, _) => Text('Error: $e'),
        data: (state) {
          if (state is MembershipNone) {
            return NoGymMembershipHomeScreen(); // 👈 return
          }
          if (state is MembershipLoaded) {
            final membership = state.current;
            final status = state.sessionStatus;
            return HomeMembershipWidget(
              membership: membership,
              status: status,
            );
          }

          return const SizedBox.shrink(); // 👈 return
        },
      ),
    );
  }
}

// // Refresh from API (re-fetch all memberships)
// ref.read(activeMembershipProvider.notifier).refresh();

// // Switch to a different gym membership
// ref.read(activeMembershipProvider.notifier).switchMembership(membershipId);

// // Clear on logout — wipe persisted selection
// ref.read(activeMembershipProvider.notifier).clear();

// bool hasActiveMembership() {
//   final state = ref.read(activeMembershipProvider).asData?.value;
//   if (state is MembershipLoaded) {
//     return state.sessionStatus == MembershipSessionStatus.active;
//   }
//   return false;
// }
