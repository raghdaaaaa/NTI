import 'package:bmi/Screens/home_screen.dart';
import 'package:bmi/widgets/count_card.dart';
import 'package:bmi/widgets/gender_card.dart';
import 'package:bmi/widgets/hieght_sider.dart';
import 'package:flutter/material.dart';

import 'result.dart';

const kBackgroundColor = Color(0xFF0A0C1B);
const kCardColor = Color(0xFF141A31);
const kSelectedCardColor = Color(0xFF1D1E33);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMale = false;
  bool isFemale = false;
  double height = 155;
  int weight = 50;
  int age = 20;

  void _calculate() {
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
                    isSelected: isFemale,
                    onTap: () => setState(() {
                      isFemale = true;
                      isMale = false;
                    }),
                  ),
                  const SizedBox(width: 16),
                  GenderCard(
                    icon: Icons.male,
                    label: 'MALE',
                    isSelected: isMale,
                    onTap: () => setState(() {
                      isMale = true;
                      isFemale = false;
                    }),
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
