import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rooster/Screen/HomeScreen.dart';
import 'package:rooster/Screen/LoginScreen.dart';
import 'package:rooster/services/api_service.dart';

import 'package:rooster/services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _startAnimations();
    _checkLoginStatus();
  }

  void _startAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _logoAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final token = await storage.read(key: 'token');
      debugPrint(
          'Splash: token="$token", pendingNotificationArgs=${NotificationService.pendingNotificationArgs}');

      if (token != null && token.isNotEmpty) {
        if (NotificationService.pendingNotificationArgs != null) {
          final args = Map<String, dynamic>.from(
              NotificationService.pendingNotificationArgs!);
          NotificationService.pendingNotificationArgs = null;
          Get.offAll(() => const HomeScreen());
          Future.delayed(const Duration(milliseconds: 300), () {
            ApiService.handleNotificationNavigation(args['type'], args['id']);
          });
        } else {
          Get.offAll(() => const HomeScreen());
        }
      } else {
        Get.offAll(() => const LoginScreen());
      }
    } catch (e, st) {
      debugPrint('Error reading token in splash: $e\n$st');
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: ScaleTransition(
                scale: _logoAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Rooster'.tr,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            'Handbuch'.tr,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: theme.primaryColor,
                  strokeWidth: 2.5,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
