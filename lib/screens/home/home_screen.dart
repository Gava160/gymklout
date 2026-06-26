import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/home/widgets/header.dart';
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
          child: Column(
            children: [
              Header(),
              ReuseableBlockHeader(
                title: "Recommended for you",
                actionText: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
