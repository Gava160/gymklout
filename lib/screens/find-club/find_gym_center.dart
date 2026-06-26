import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class FindGymCenterScreen extends StatefulWidget {
  const FindGymCenterScreen({super.key});

  @override
  State<FindGymCenterScreen> createState() => _FindGymCenterScreenState();
}

class _FindGymCenterScreenState extends State<FindGymCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: AppDefaults.defaultPadding,
        child: SingleChildScrollView(child: Column(children: [
  
        ])),
      ),
    );
  }
}
