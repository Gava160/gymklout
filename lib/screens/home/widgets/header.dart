import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final customer = ref.watch(authStateProvider).asData?.value;

    return Padding(
      padding: AppDefaults.defaultPadding,
      child: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                                  (AppDefaults.headLiner1(context).fontSize ??
                                      21) +
                                  15,
                            ),
                      ),
                      Text(
                        "Juietta",
                        style:
                            AppDefaults.headLiner1(
                              context,
                              fontWeight: FontWeight.w800,
                            ).copyWith(
                              color: getDefaultHeaderColor(context),
                              fontSize:
                                  (AppDefaults.headLiner1(context).fontSize ??
                                      21) +
                                  15,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                getGreeting(),
                style: AppDefaults.textStyle(context).copyWith(
                  color: AppDefaults.textStyle(context).color,
                  fontWeight: FontWeight.w100,
                  fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) - 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
