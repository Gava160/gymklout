import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class ProcessheaderWidget extends StatelessWidget {
  const ProcessheaderWidget({super.key, required this.header, required this.subHeader});

  final String header;
  final String subHeader;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.90,
          child: Text(
            header,
            style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w700)
                .copyWith(
                  color: getDefaultHeaderColor(context),
                  fontSize: (AppDefaults.headLiner1(context).fontSize ?? 21),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 7),
        SizedBox(
          width: size.width * 0.80,
          child: Text(
            subHeader,
            style: AppDefaults.textStyle(context, fontWeight: FontWeight.w400)
                .copyWith(
                  color: getDefaultHeaderColor(context, lightAlpha: 200),
                  fontSize: (AppDefaults.textStyle(context).fontSize ?? 21),
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
