import 'package:flutter/material.dart';

import '../Core/constants.dart';

enum BmiCategory {
  underweight(
    'UNDERWEIGHT',
    Colors.yellow,
    'You have a lower than normal body weight.',
  ),
  normal(
    'NORMAL',
    Color(0xFF00E676),
    'You have a normal body weight. Good job!',
  ),
  overweight(
    'OVERWEIGHT',
    Colors.orange,
    'You have a higher than normal body weight.',
  ),
  obese('OBESE', Colors.red, 'You have a much higher than normal body weight.');

  final String label;
  final Color color;
  final String message;

  const BmiCategory(this.label, this.color, this.message);

  static BmiCategory fromBmi(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25) return normal;
    if (bmi < 30) return overweight;
    return obese;
  }
}

class ResultScreen extends StatelessWidget {
  final double bmi;

  const ResultScreen({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    final category = BmiCategory.fromBmi(bmi);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Result:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        category.label,
                        style: TextStyle(
                          color: category.color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          category.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
