import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'state/task_provider.dart';
import 'state/auth_provider.dart';
import 'state/theme_provider.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'utils/app_theme.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final authService = AuthService(sharedPrefs);
  final storageService = StorageService(sharedPrefs);
  final notificationService = NotificationService();

  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => authService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService)..loadUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(storageService)..loadTasks(),
        ),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Todo App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.user == null
              ? const AuthScreen()
              : const HomeScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
