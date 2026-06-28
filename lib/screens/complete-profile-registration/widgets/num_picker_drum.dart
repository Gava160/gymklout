import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class NumberPickerDrum extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const NumberPickerDrum({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<NumberPickerDrum> createState() => _NumberPickerDrumState();
}

class _NumberPickerDrumState extends State<NumberPickerDrum> {
  late FixedExtentScrollController _controller;
  late int _selectedValue;

  static const double itemExtent = 70.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _controller = FixedExtentScrollController(
      initialItem: widget.initialValue - widget.minValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemExtent * 7, // shows 7 items (3 above, selected, 3 below)
      width: 160,
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

          // Scroll picker
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.003,
            diameterRatio: 2.5,
            onSelectedItemChanged: (index) {
              setState(() => _selectedValue = widget.minValue + index);
              widget.onChanged(_selectedValue);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.maxValue - widget.minValue + 1,
              builder: (context, index) {
                final value = widget.minValue + index;
                final isSelected = value == _selectedValue;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w400,
                        ).copyWith(
                          fontSize: isSelected ? 52 : 28,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.withOpacity(
                                  (1 - ((value - _selectedValue).abs() * 0.25))
                                      .clamp(0.3, 0.7),
                                ),
                        ),
                    child: Text('$value'),
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
