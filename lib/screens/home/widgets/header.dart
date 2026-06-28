import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/providers/auth_provider.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  // greetings
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  // get initials
  String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '';
    final names = fullName.trim().split(RegExp(r'\s+'));
    return names
        .where((name) => name.isNotEmpty)
        .map((name) => name[0])
        .take(2) // remove this line if you want ALL initials
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Hello ",
                style:
                    AppDefaults.headLiner1(
                      context,
                      fontWeight: FontWeight.w200,
                    ).copyWith(
                      color: getDefaultHeaderColor(context),
                      fontSize:
                          (AppDefaults.headLiner1(context).fontSize ?? 21) + 15,
                    ),
              ),
              Text(
                toTitleCase(profile?.fullName.split(' ').last ?? ''),
                style:
                    AppDefaults.headLiner1(
                      context,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      color: getDefaultHeaderColor(context),
                      fontSize:
                          (AppDefaults.headLiner1(context).fontSize ?? 21) + 15,
                    ),
              ),
            ],
          ),
          Text(
            getGreeting(),
            style: AppDefaults.textStyle(context).copyWith(
              color: AppDefaults.textStyle(context).color,
              fontWeight: FontWeight.w100,
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) + 3,
            ),
          ),
        ],
      ),
    );
  }
}
