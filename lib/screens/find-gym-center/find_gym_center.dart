import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/screens/find-gym-center/tabs/gym_centers_map.dart';
import 'package:gymklout/screens/find-gym-center/tabs/gym_centers_nearby.dart';
import 'package:iconsax/iconsax.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kTextTabBarHeight + 35),
        child: SafeArea(
          child: Padding(
            padding: AppDefaults.defaultPadding,
            child: CustomAppBar(title: "Find a Gym", actions: []),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: AppDefaults.defaultPadding.copyWith(top: 0,),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppDefaults.textColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(60),
                    // shape: BoxShape.circle,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.search_normal,
                        color: AppDefaults.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search for gym centers',
                          style: AppDefaults.textStyle(
                            context,
                          ).copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(color: Colors.grey.withAlpha(20), width: 1),
                ),
              ),
              child: TabBar(
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                // indicator: UnderlineTabIndicator(
                //   borderSide: BorderSide(
                //     color: darken(AppDefaults.primaryColor, 0.3),
                //     width: 7,
                //   ),
                // ),
                indicator: MyTabIndicator(),
                labelColor: Colors.white,
                unselectedLabelColor: AppDefaults.textColor,
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey.withAlpha(20),
                            width: 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'FIND ON MAP',
                        style:
                            AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                  21),
                            ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey.withAlpha(20),
                            width: 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'NEAR BY',
                        style:
                            AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                  21),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [GymCentersMapWidget(), GymCentersNearbyWidget()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyPainter();
  }
}
class _MyPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final rect = offset & (config.size ?? Size.zero);

    final gradient = LinearGradient(
      colors: [
        darken(AppDefaults.primaryColor, 0.3),
        AppDefaults.primaryColor,
        darken(AppDefaults.primaryColor, 0.3),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          rect.left + 24,
          rect.bottom - 3,
          rect.width - 48,
          3,
        ),
      )
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(rect.left + 24, rect.bottom - 1.5),
      Offset(rect.right - 24, rect.bottom - 1.5),
      paint,
    );
  }
}