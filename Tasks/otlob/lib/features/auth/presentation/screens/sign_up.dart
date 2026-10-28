import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/shared/submit_button.dart';
import 'package:otlob/core/shared/validators.dart';
import 'package:otlob/features/account/data/services/account_service.dart';
import 'package:otlob/features/auth/data/models/register_dto.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/auth/presentation/widgets/driver.dart';
import 'package:otlob/features/auth/presentation/widgets/footer.dart';
import 'package:otlob/features/auth/presentation/widgets/forms.dart';
import 'package:otlob/features/auth/presentation/widgets/header.dart';
import 'package:otlob/features/auth/presentation/widgets/log_option.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bool emailExists;
      try {
        emailExists = await AccountService().emailExists(
          emailController.text.trim(),
        );
      } on AccountException catch (error) {
        throw AuthException(error.message);
      }
      if (emailExists) {
        throw const AuthException('An account with this email already exists.');
      }

      final user = await AuthService().register(
        RegisterDto(
          displayName: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
        ),
      );

      if (!mounted) return;

      if (user.token?.trim().isNotEmpty == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: Color(0xFFFF5C39),
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please check your inputs.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Header(
                  title: "Create an account",
                  subTitle: "Connect with your friends today!",
                ),
                const SizedBox(height: 30),
                Forms(
                  text: "Name",
                  hint: "Enter your name",
                  controller: nameController,
                  validator: (val) => Validator.validateUserName(val ?? ''),
                ),
                const SizedBox(height: 16),
                Forms(
                  text: "Email Address",
                  hint: "Enter your email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => Validator.validateEmail(val ?? ''),
                ),
                const SizedBox(height: 16),
                Forms(
                  text: "Phone Number",
                  hint: "Enter your phone",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => Validator.validatePhoneNumber(val ?? ''),
                ),
                const SizedBox(height: 16),
                Forms(
                  text: "Password",
                  hint: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                  validator: (val) => Validator.validatePassword(val ?? ''),
                ),
                const SizedBox(height: 20),
                SubmitButton(
                  onTap: _isLoading ? null : _handleSignUp,
                  isLoading: _isLoading,
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
      ),
    );
  }
}
