import 'package:flutter/material.dart';
import 'package:otlob/core/network/auth_session.dart';
import 'package:otlob/core/routes/app_routes.dart';
import 'package:otlob/core/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.session});

  final AuthSession? session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otlob',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(
        settings,
        session: session ?? AuthSession.instance,
      ),
      initialRoute: AppRoutes.startup,
    );
  }
}
