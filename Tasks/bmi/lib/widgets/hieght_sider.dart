import 'package:flutter/material.dart';

class HeightSlider extends StatelessWidget {
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
        const padding = 24.0;
        const pinOffset = 19.0;
        final trackWidth = constraints.maxWidth - padding * 2;
        final pinLeft = padding + (height / 200) * trackWidth - pinOffset;

        return Column(
          children: [
            SizedBox(
              height: 40,
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  Positioned(
                    left: pinLeft.clamp(0.0, constraints.maxWidth - 38),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 38,
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
                activeTrackColor: const Color(0xFF6C63FF),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.red,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6.0,
                ),
              ),
              child: Slider(value: height, max: 200, onChanged: onChanged),
            ),
          ],
        );
      },
    );
  }
}
