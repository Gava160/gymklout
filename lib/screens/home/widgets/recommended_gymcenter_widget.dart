import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/index.dart';

class RecommendedGymCenters extends StatefulWidget {
  final List<GymModel> gyms;
  final int maxItems;
  final String? closestGymId;
  final void Function(GymModel gym)? onTap;

  const RecommendedGymCenters({
    super.key,
    required this.gyms,
    this.maxItems = 5,
    this.closestGymId,
    this.onTap,
  });

  @override
  State<RecommendedGymCenters> createState() => _RecommendedGymCentersState();
}

class _RecommendedGymCentersState extends State<RecommendedGymCenters> {
  late PageController _pageController;
  double _currentPage = 0;

  List<GymModel> get _items =>
      widget.gyms.take(widget.maxItems).toList(growable: false);

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
    if (_items.isEmpty) {
      return const SizedBox.shrink(); // or an empty-state widget
    }

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

          final gym = _items[index];
          final isClosest = widget.closestGymId != null &&
              gym.id == widget.closestGymId;

          return Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: widget.onTap != null ? () => widget.onTap!(gym) : null,
              child: _GymCard(gym: gym, isClosest: isClosest, isFirst: index == 0),
            ),
          );
        },
      ),
    );
  }
}

// The Card Widget
class _GymCard extends StatelessWidget {
  final GymModel gym;
  final bool isClosest;
  final bool isFirst;

  const _GymCard({
    required this.gym,
    required this.isClosest,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = gym.coverUrl != null || gym.logoUrl != null;
    final imageProvider = hasImage
        ? NetworkImage(gym.coverUrl ?? gym.logoUrl!) as ImageProvider
        : const AssetImage('assets/images/gym_placeholder.png');

    final locationLine = [
      if (gym.city != null) gym.city,
      if (gym.state != null) gym.state,
    ].whereType<String>().join(', ');

    return Container(
      margin: EdgeInsets.only(
        left: isFirst ? 0 : 8,
        right: 0,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
      child: Container(
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
            // tag — CLOSEST TO YOU or VERIFIED
            if (isClosest || gym.isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppDefaults.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isClosest ? 'CLOSEST TO YOU' : 'VERIFIED',
                  style: AppDefaults.textStyle(
                    context,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppDefaults.white, fontSize: 11),
                ),
              ),

            const Spacer(),

            // first amenity as category-style label
            if (gym.amenities.isNotEmpty)
              Text(
                gym.amenities.first.toUpperCase(),
                style: AppDefaults.textStyle(context).copyWith(
                  color: AppDefaults.white.withAlpha(180),
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            const SizedBox(height: 4),

            // gym name
            Text(
              gym.name,
              style: AppDefaults.headLiner1(
                context,
                fontWeight: FontWeight.w800,
              ).copyWith(color: AppDefaults.white, fontSize: 22),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // city/state
            if (locationLine.isNotEmpty)
              Text(
                locationLine,
                style: AppDefaults.textStyle(
                  context,
                ).copyWith(color: AppDefaults.white),
              ),

            // distance
            if (gym.distanceLabel.isNotEmpty)
              Text(
                gym.distanceLabel,
                style: AppDefaults.textStyle(
                  context,
                ).copyWith(color: AppDefaults.white),
              ),

            const SizedBox(height: 12),

            // address row (replaces trainer row — no member data on this model yet)
            if (gym.address != null)
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: AppDefaults.white.withAlpha(180), size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      gym.address!,
                      style: AppDefaults.textStyle(context).copyWith(
                        color: AppDefaults.white.withAlpha(180),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}