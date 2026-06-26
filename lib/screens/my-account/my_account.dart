import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
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
