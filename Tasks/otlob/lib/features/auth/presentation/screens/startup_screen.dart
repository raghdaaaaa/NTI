import 'package:flutter/material.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final hasSession = await widget.session.restoreSession();
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(hasSession ? AppRoutes.main : AppRoutes.login);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'Unable to restore your saved session. You can continue to login.';
      });
    }
  }

  void _continueToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    return Scaffold(
      body: Center(
        child: error == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _continueToLogin,
                      child: const Text('Continue to login'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
