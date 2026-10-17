import 'package:flutter/material.dart';
import 'package:otlob/Core/Constants/app_assets.dart';
import 'package:otlob/Core/Routes/app_routes.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/driver.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/footer.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/forms.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/header.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/log_option.dart';
import 'package:otlob/Features/Screens/Auth/Widgets/submit_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Header(
                title: "Create an account",
                subTitle: "Connect with your friends today!",
              ),
              const SizedBox(height: 30),
              const Forms(text: "Name", hint: "Enter your name"),
              const SizedBox(height: 16),
              const Forms(text: "Email Address", hint: "Enter your email"),
              const SizedBox(height: 16),
              const Forms(text: "Phone Number", hint: "Enter your phone"),
              const SizedBox(height: 16),
              const Forms(
                text: "Password",
                hint: "Enter your password",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              SubmitButton(
                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                title: "Sign Up",
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
                text: "Already have an account?",
                actionText: "Login",
                onTap: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
