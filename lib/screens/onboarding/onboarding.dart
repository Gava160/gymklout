import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/screens/authentication/signin/signin.dart';
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
  late Timer timer;
  late List<Widget> _pages;

  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SignInScreen()),
      (Route<dynamic> route) => false, // remove all previous routes
    );
  }

  void _startAutoSlide() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentIndex < _pages.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // loop back to first page
      }

      _controller.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
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
    _startAutoSlide();
    _pages = [
      OnboardPage(
        image: AppMedia.onboarding2,
        lighterText: "Meet your coach,",
        thickerText: "Start your journey",
        finishOnboarding: () {},
      ),
      OnboardPage(
        image: AppMedia.onboarding1,
        lighterText: "Create a workout plan",
        thickerText: "to stay fit",
        finishOnboarding: () {},
      ),

      OnboardPage(
        image: AppMedia.onboarding3,
        lighterText: "Action is the",
        thickerText: "key to all success",
        endOnboarding: true,
        finishOnboarding: () async {
          finishOnboarding();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: getDefaultBgColor(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onPanDown: (_) => timer.cancel(),
              onPanCancel: () => _startAutoSlide(),
              onPanEnd: (_) => _startAutoSlide(),
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) => _pages[index],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 60),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 45 : 15,
                  height: 2,
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
        ),
      ),
    );
  }
}

class SlantedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height); // bottom-left point (pulled up)
    path.lineTo(
      size.width,
      size.height - 70,
    ); // bottom-right point (full height)
    path.lineTo(size.width, 0); // top-right
    path.close(); // back to top-left

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class OnboardPage extends StatelessWidget {
  final String thickerText;
  final String lighterText;
  final String image;
  final bool endOnboarding;
  final VoidCallback finishOnboarding;

  const OnboardPage({
    super.key,
    required this.thickerText,
    required this.lighterText,
    required this.image,
    this.endOnboarding = false,
    required this.finishOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipPath(
              clipper: SlantedBottomClipper(),
              child: Container(
                width: double.infinity,
                height: size.height * 0.60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipPath(
                clipper: SlantedBottomClipper(),
                child: Container(color: AppDefaults.darkBgColor.withAlpha(170)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        Text(
          lighterText,
          style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w200)
              .copyWith(
                color: getDefaultHeaderColor(context, lightAlpha: 150),
                fontSize: (AppDefaults.headLiner1(context).fontSize ?? 21) + 4,
              ),
        ),
        Text(
          thickerText,
          style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w800)
              .copyWith(
                color: getDefaultHeaderColor(context, lightAlpha: 230),
                fontSize: (AppDefaults.headLiner1(context).fontSize ?? 21) + 6,
              ),
        ),

        if (endOnboarding) ...[
          SizedBox(height: 25),
          SizedBox(
            width: size.width * 0.50,
            child: AppCustomButton(
              noPadding: true,
              label: Text(
                "Start Now",
                style:
                    AppDefaults.textStyle(
                      context,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      color: AppDefaults.white,
                      fontSize:
                          (AppDefaults.textStyle(context).fontSize ?? 16) + 4,
                    ),
              ),
              icon: Icon(FluentIcons.arrow_right_12_regular, size: 20),
              onSubmit: finishOnboarding,
            ),
          ),
        ],
      ],
    );
  }
}
