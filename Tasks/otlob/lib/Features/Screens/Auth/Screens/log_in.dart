import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_assets.dart';
import 'package:otlob/Core/Routes/app_routes.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/driver.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/footer.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/forms.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/header.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/log_option.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/remember.dart';
import 'package:otlob/Core/shared/submit_button.dart';

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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Header(
                title: "Hi, Welcome Back! 👋",
                subTitle: "Hello again, you've been missed!",
              ),
              const SizedBox(height: 30),
              const Forms(text: "Email", hint: "Enter your email"),
              const SizedBox(height: 16),
              const Forms(
                text: "Password",
                hint: "Enter your password",
                isPassword: true,
              ),
              const SizedBox(height: 16),
              const Remember(),
              const SizedBox(height: 20),
              SubmitButton(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.home),
                title: "Login",
              ),
              const SizedBox(height: 20),
              const Driver(),
              const SizedBox(height: 20),
              Row(
                children: [
                  LogOption(imagePath: AppAssets.github, text: "GitHub"),
                  const SizedBox(width: 16),
                  LogOption(imagePath: AppAssets.gitlab, text: "GitLab"),
                ],
              ),
              const SizedBox(height: 30),
              Footer(
                text: "Don't have an account?",
                actionText: "Sign Up",
                onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
