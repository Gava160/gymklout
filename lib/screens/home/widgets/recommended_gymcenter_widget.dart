import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';

class RecommendedGymCenters extends StatefulWidget {
  const RecommendedGymCenters({super.key});

  @override
  State<RecommendedGymCenters> createState() => _RecommendedGymCentersState();
}

class _RecommendedGymCentersState extends State<RecommendedGymCenters> {
  late PageController _pageController;
  double _currentPage = 0;

  // dummy data — replace with your real model later
  final List<Map<String, String>> _items = [
    {
      'image': AppMedia.onboarding3, // replace with your images
      'tag': 'NEW',
      'category': 'AERIAL WORKOUTS',
      'title': 'Lift it again',
      'subtitle': 'Upper Body • Weights',
      'duration': 'Beginner • 24 min',
      'trainerName': 'Jane Doe',
      'trainerRole': 'Aerial Workouts Trainer',
    },
    {
      'image': AppMedia.onboarding3,
      'tag': 'HOT',
      'category': 'STRENGTH',
      'title': 'Power Up',
      'subtitle': 'Full Body • Barbell',
      'duration': 'Intermediate • 45 min',
      'trainerName': 'John Smith',
      'trainerRole': 'Strength Coach',
    },
    {
      'image': AppMedia.onboarding3,
      'tag': 'NEW',
      'category': 'CARDIO',
      'title': 'Burn Zone',
      'subtitle': 'Lower Body • HIIT',
      'duration': 'Advanced • 30 min',
      'trainerName': 'Sara Lee',
      'trainerRole': 'Cardio Specialist',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.50,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        padEnds: false,
        itemBuilder: (context, index) {
          double distance = (_currentPage - index).abs();
          double scale = (1 - (distance * 0.12)).clamp(0.88, 1.0);

          return Transform.scale(
            scale: scale,
            child: _GymCard(item: _items[index], isFirst: index == 0),
          );
        },
      ),
    );
  }
}

// The Card Widget
class _GymCard extends StatelessWidget {
  final Map<String, String> item;
  final bool isFirst;
  const _GymCard({required this.item, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: isFirst ? 0 : 8, // 👈 no left margin on first card
        right: 0,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(item['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // dark overlay
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppDefaults.darkBgColor.withAlpha(220),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NEW / HOT tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppDefaults.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item['tag']!,
                style: AppDefaults.textStyle(
                  context,
                  fontWeight: FontWeight.w600,
                ).copyWith(color: AppDefaults.white, fontSize: 11),
              ),
            ),

            const Spacer(),

            // category
            Text(
              item['category']!,
              style: AppDefaults.textStyle(context).copyWith(
                color: AppDefaults.white.withAlpha(180),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),

            // title
            Text(
              item['title']!,
              style: AppDefaults.headLiner1(
                context,
                fontWeight: FontWeight.w800,
              ).copyWith(color: AppDefaults.white, fontSize: 22),
            ),
            const SizedBox(height: 4),

            // subtitle + duration
            Text(
              item['subtitle']!,
              style: AppDefaults.textStyle(
                context,
              ).copyWith(color: AppDefaults.white),
            ),
            Text(
              item['duration']!,
              style: AppDefaults.textStyle(
                context,
              ).copyWith(color: AppDefaults.white),
            ),
            const SizedBox(height: 12),

            // trainer row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    item['image']!,
                  ), // replace with trainer image
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['trainerName']!,
                      style: AppDefaults.textStyle(
                        context,
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: AppDefaults.white),
                    ),
                    Text(
                      item['trainerRole']!,
                      style: AppDefaults.textStyle(context).copyWith(
                        color: AppDefaults.white.withAlpha(180),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
