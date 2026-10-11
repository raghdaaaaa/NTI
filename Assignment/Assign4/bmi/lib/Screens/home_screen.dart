import 'package:flutter/material.dart';

import '../Core/constants.dart';
import '../widgets/count_card.dart';
import '../widgets/gender_card.dart';
import '../widgets/hieght_sider.dart';
import 'result.dart';

enum Gender { male, female, devloper }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Gender? selectedGender;
  double height = 155;
  int weight = 50;
  int age = 20;

  void _calculate() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    final heightInMeters = height / 100;
    final bmi = heightInMeters > 0
        ? weight / (heightInMeters * heightInMeters)
        : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(bmi: bmi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BMI calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GenderCard(
                    icon: Icons.female,
                    label: 'FEMALE',
                    isSelected: selectedGender == Gender.female,
                    onTap: () => setState(() => selectedGender = Gender.female),
                  ),
                  const SizedBox(width: 16),
                  GenderCard(
                    icon: Icons.male,
                    label: 'MALE',
                    isSelected: selectedGender == Gender.male,
                    onTap: () => setState(() => selectedGender = Gender.male),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          'HEIGHT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CM',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    HeightSlider(
                      height: height,
                      onChanged: (val) => setState(() => height = val),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CounterCard(
                    label: 'WEIGHT',
                    value: weight,
                    onIncrement: () => setState(() => weight++),
                    onDecrement: () => setState(() {
                      if (weight > 1) weight--;
                    }),
                  ),
                  const SizedBox(width: 16),
                  CounterCard(
                    label: 'AGE',
                    value: age,
                    onIncrement: () => setState(() => age++),
                    onDecrement: () => setState(() {
                      if (age > 1) age--;
                    }),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: _calculate,
            child: Container(
              width: double.infinity,
              height: 65,
              color: Colors.red,
              child: const Center(
                child: Text(
                  'CALCULATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
