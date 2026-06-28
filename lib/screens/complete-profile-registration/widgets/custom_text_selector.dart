import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class CustomTextSelectorWidget extends StatefulWidget {
  final List<String> goals;
  final int initialIndex;
  final ValueChanged<String> onChanged;

  const CustomTextSelectorWidget({
    super.key,
    required this.goals,
    this.initialIndex = 0,
    required this.onChanged,
  });

  @override
  State<CustomTextSelectorWidget> createState() => _GoalPickerDrumState();
}

class _GoalPickerDrumState extends State<CustomTextSelectorWidget> {
  late FixedExtentScrollController _controller;
  late int _selectedIndex;

  static const double itemExtent = 60.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemExtent * 5, // shows 5 items (2 above, selected, 2 below)
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Purple lines
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 3, color: AppDefaults.primaryColor),
              SizedBox(height: itemExtent - 2),
              Container(height: 3, color: AppDefaults.primaryColor),
            ],
          ),

          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.003,
            diameterRatio: 2.5,
            onSelectedItemChanged: (index) {
              setState(() => _selectedIndex = index);
              widget.onChanged(widget.goals[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.goals.length,
              builder: (context, index) {
                final isSelected = index == _selectedIndex;
                final distance = (index - _selectedIndex).abs();
                final opacity = (1.0 - (distance * 0.3)).clamp(0.2, 1.0);

                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w400,
                        ).copyWith(
                          fontSize: isSelected ? 32 : 23,
                          color: Colors.white.withOpacity(opacity),
                        ),

                    child: Text(
                      widget.goals[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
