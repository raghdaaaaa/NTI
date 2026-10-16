import 'package:flutter/material.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/driver.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/forms.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/header.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/remember.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/submit_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Header(
                title: "Hi , Welcome Back !",
                subTitle: "Hello again, you've been missed!",
              ),
              const SizedBox(height: 50),
              Forms(
                label: "Email",
                hint: "raghdaa@gmail.com",
                textController: emailController,
              ),
              const SizedBox(height: 20),
              Forms(
                label: "Password",
                hint: "Enter your password",
                isPassword: true,
                textController: passwordController,
              ),
              const SizedBox(height: 20),
              const Remember(),
              const SizedBox(height: 20),
              SubmitButton(onTap: () {}, title: "Login"),
              const SizedBox(height: 20),
              const Driver(),
            ],
          ),
        ),
      ),
    );
  }
}
