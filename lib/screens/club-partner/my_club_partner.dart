import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class MyClubPartnerScreen extends StatefulWidget {
  const MyClubPartnerScreen({super.key});

  @override
  State<MyClubPartnerScreen> createState() => _MyClubPartnerScreenState();
}

class _MyClubPartnerScreenState extends State<MyClubPartnerScreen> {
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
