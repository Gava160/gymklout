import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class RulerWeightPicker extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final String unit;

  const RulerWeightPicker({
    super.key,
    this.minValue = 30,
    this.maxValue = 200,
    this.initialValue = 54,
    required this.onChanged,
    this.unit = 'kg',
  });

  @override
  State<RulerWeightPicker> createState() => _RulerWeightPickerState();
}

class _RulerWeightPickerState extends State<RulerWeightPicker> {
  late ScrollController _scrollController;
  late double _selectedValue;

  static const double itemSpacing = 12.0; // spacing between ticks

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    final initialOffset =
        (widget.initialValue - widget.minValue) * itemSpacing * 2;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final value =
        widget.minValue + (_scrollController.offset / (itemSpacing * 2));
    final clamped = value.clamp(widget.minValue, widget.maxValue);
    final rounded =
        (clamped * 1).round() / 1; // whole numbers; use 2 for decimals
    if (rounded != _selectedValue) {
      setState(() => _selectedValue = rounded);
      widget.onChanged(rounded);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalTicks = ((widget.maxValue - widget.minValue) * 2).toInt() + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Value display
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _selectedValue.toInt().toString(),
                style:
                    AppDefaults.headLiner1(
                      context,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      color: getDefaultHeaderColor(context),
                      fontSize:
                          (AppDefaults.headLiner1(context).fontSize ?? 21) + 40,
                    ),
              ),
              TextSpan(
                text: ' ${widget.unit}',
                style:
                    AppDefaults.textStyle(
                      context,
                      fontWeight: FontWeight.w400,
                    ).copyWith(
                      color: getDefaultHeaderColor(context, lightAlpha: 200),
                      fontSize: (AppDefaults.textStyle(context).fontSize ?? 21),
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Ruler
        SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Center indicator line
              Positioned(
                top: 0,
                child: Container(
                  width: 2.5,
                  height: 100,
                  color: AppDefaults.primaryColor,
                ),
              ),

              // Scrollable ticks
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: totalTicks,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 2,
                ),
                itemExtent: itemSpacing,
                itemBuilder: (context, index) {
                  final value = widget.minValue + (index * 0.5);
                  final isMajor = index % 2 == 0; // whole numbers are major
                  final distance = (value - _selectedValue).abs();
                  final opacity = (1.0 - (distance / 15)).clamp(0.15, 1.0);

                  return Center(
                    child: Container(
                      width: 2,
                      height: isMajor ? 40 : 22,
                      decoration: BoxDecoration(
                        color: AppDefaults.primaryColor.withOpacity(opacity),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
