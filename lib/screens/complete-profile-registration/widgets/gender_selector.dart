import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';

class GenderSelectorWidget extends StatelessWidget {
  const GenderSelectorWidget({
    super.key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onSelect,
  });

  final String value;
  final String label;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        width: isSelected ? 180 : 150,
        height: isSelected ? 180 : 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppDefaults.primaryColor
              : AppDefaults.textColor.withAlpha(50),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                value == "male"
                    ? FontAwesomeIcons.mars
                    : FontAwesomeIcons.venus,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(height: 15),
              Text(
                label,
                style:
                    AppDefaults.textStyle(
                      context,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      color: getDefaultHeaderColor(context),
                      fontSize:
                          (AppDefaults.textStyle(context).fontSize ?? 21) + 4,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
