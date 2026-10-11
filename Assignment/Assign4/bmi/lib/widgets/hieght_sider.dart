import 'package:flutter/material.dart';

import '../Core/constants.dart';

class HeightSlider extends StatelessWidget {
  static const double _max = 200;
  static const double _padding = 24.0;
  static const double _pinSize = 38.0;

  final double height;
  final ValueChanged<double> onChanged;

  const HeightSlider({
    super.key,
    required this.height,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth - _padding * 2;
        final pinLeft = _padding + (height / _max) * trackWidth - _pinSize / 2;

        return Column(
          children: [
            SizedBox(
              height: 40,
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  Positioned(
                    left: pinLeft.clamp(0.0, constraints.maxWidth - _pinSize),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: _pinSize,
                        ),
                        Positioned(
                          top: 5,
                          child: Text(
                            '${height.round()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: kActiveTrackColor,
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.red,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6.0,
                ),
              ),
              child: Slider(value: height, max: _max, onChanged: onChanged),
            ),
          ],
        );
      },
    );
  }
}
