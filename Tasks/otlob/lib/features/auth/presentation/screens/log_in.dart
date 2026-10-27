import 'package:flutter/material.dart';
import 'package:otlob/core/constants/app_assets.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/shared/submit_button.dart';
import 'package:otlob/core/shared/validators.dart';
import 'package:otlob/features/auth/data/models/login_dto.dart';
import 'package:otlob/features/auth/data/services/auth_service.dart';
import 'package:otlob/features/auth/presentation/widgets/driver.dart';
import 'package:otlob/features/auth/presentation/widgets/footer.dart';
import 'package:otlob/features/auth/presentation/widgets/forms.dart';
import 'package:otlob/features/auth/presentation/widgets/header.dart';
import 'package:otlob/features/auth/presentation/widgets/log_option.dart';
import 'package:otlob/features/auth/presentation/widgets/remember.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthService().login(
        LoginDto(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );

      if (!mounted) return;

      if (user.token != null && user.token!.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login succeeded, but no session token was received.'),
            backgroundColor: Color(0xFFFF5C39),
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
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
                  title: "Hi, Welcome Back! 👋",
                  subTitle: "Hello again, you've been missed!",
                ),
                const SizedBox(height: 30),
                Forms(
                  text: "Email",
                  hint: "Enter your email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => Validator.validateEmail(val ?? ''),
                ),
                const SizedBox(height: 16),
                Forms(
                  text: "Password",
                  hint: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                  validator: (val) => Validator.validatePassword(val ?? ''),
                ),
                const SizedBox(height: 16),
                const Remember(),
                const SizedBox(height: 20),
                SubmitButton(
                  onTap: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
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
      ),
    );
  }
}
