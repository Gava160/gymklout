import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymklout/app-settings/media.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  String nextButtonText = "Next";
  late Timer timer;

  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  final List<Widget> _pages = [
    OnboardPage(
      image: Image.asset(AppMedia.logoIconWhite),
      title: "Buy Grocery",
      description:
          "Easily order groceries from your favorite local stores and have them delivered to your doorstep in no time.",
    ),
    OnboardPage(
      image: Image.asset(AppMedia.logoIconWhite),
      title: "Fast & Reliable Delivery",
      description:
          "Get your orders delivered quickly and reliably, no matter where you are. Experience seamless delivery like never before.",
    ),
    OnboardPage(
      image: Image.asset(AppMedia.logoIconWhite),
      title: "Enjoy Quality Food",
      description:
          "Discover a wide range of delicious meals from your favorite restaurants, all delivered fresh and fast.",
    ),
   
  ];

  // void _startAutoSlide() {
  //   timer = Timer.periodic(Duration(seconds: 3), (timer) {
  //     if (currentIndex < _pages.length - 1) {
  //       currentIndex++;
  //     } else {
  //       currentIndex = 0; // loop back to first page
  //     }

  //     _controller.animateToPage(
  //       currentIndex,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  void _nextSlide() {
    // continue
    if (currentIndex < _pages.length - 1) {
      currentIndex++;
    } else {
      // currentIndex = 0; // loop back to first page

      finishOnboarding();
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => ChooseSigninScreen()),
      //   (Route<dynamic> route) => false, // remove all previous routes
      // );
    }

    _controller.animateToPage(
      currentIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                child: isDark
                    ? Image.asset(AppMedia.logoWhite)
                    : Image.asset(AppMedia.logoBlack),
              ),
            ),
            Expanded(
              child: GestureDetector(
                // onPanDown: (_) => timer.cancel(),
                // onPanCancel: () => _startAutoSlide(),
                // onPanEnd: (_) => _startAutoSlide(),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      if (currentIndex == 2) {
                        nextButtonText = "Get Started";
                      } else {
                        nextButtonText = "Next";
                      }
                    });
                  },
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDefaults.defaultPadding,
          margin: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  finishOnboarding();
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => ChooseSigninScreen()),
                  //   (Route<dynamic> route) =>
                  //       false, // remove all previous routes
                  // );
                },
                child: SizedBox(
                  width: 60,
                  child: Text(
                    "Skip",
                    style: AppDefaults.textStyle(context).copyWith(
                      color: isDark
                          ? AppDefaults.white.withAlpha(150)
                          : AppDefaults.textStyle(context).color,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Indicator
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? AppDefaults.primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _nextSlide();
                },
                child: SizedBox(
                  width: 80,
                  child: Text(
                    nextButtonText,
                    style: AppDefaults.textStyle(context).copyWith(
                      color: AppDefaults.primaryColor,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String title;
  final String description;
  final Image image;

  const OnboardPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: AppDefaults.defaultPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: size.width * 0.65, child: image),
          const SizedBox(height: 40),
          Text(
            title,
            style: AppDefaults.headLiner1(context).copyWith(
              color: isDark ? AppDefaults.white : AppDefaults.headerTextColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: AppDefaults.headLine3(context)
              ..copyWith(
                color: isDark
                    ? AppDefaults.white.withAlpha(200)
                    : AppDefaults.textStyle(context).color,
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
