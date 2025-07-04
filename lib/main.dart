import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:jojocart_mobile/controller/NavigationController.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:get_storage/get_storage.dart';

import 'package:jojocart_mobile/theme/appTheme.dart';
import 'package:jojocart_mobile/view/MyHomePage.dart';

import 'controller/LocationController.dart';
import 'controller/ProductController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Show status bar, hide bottom navigation bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  await GetStorage.init();
  Get.put(LocationController());
  Get.put(ProductController());
  Get.put(NavigationController());
  await firebase.Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JojoCart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Main controller for entry animations
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Controller for continuous pulse effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Controller for rotation animations
    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _mainController.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var fadeAnimation = Tween(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            );

            return FadeTransition(opacity: fadeAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_mainController, _pulseController, _rotateController]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF5F5F5),
                  const Color(0xFFE0E6BE).withOpacity(_backgroundAnimation.value),
                  const Color(0xFFD5DCB1).withOpacity(_backgroundAnimation.value),
                  const Color(0xFFCBD29E).withOpacity(_backgroundAnimation.value),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background elements
                Positioned(
                  top: -screenHeight * 0.1,
                  left: -screenWidth * 0.2,
                  child: Opacity(
                    opacity: _backgroundAnimation.value * 0.7,
                    child: Transform.rotate(
                      angle: _rotateController.value * 2 * math.pi,
                      child: Container(
                        width: screenWidth * 0.7,
                        height: screenWidth * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFB8C13C).withOpacity(0.7),
                              const Color(0xFFB8C13C).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -screenHeight * 0.2,
                  right: -screenWidth * 0.2,
                  child: Opacity(
                    opacity: _backgroundAnimation.value * 0.6,
                    child: Transform.rotate(
                      angle: -_rotateController.value * 2 * math.pi,
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFB8C13C).withOpacity(0.5),
                              const Color(0xFFB8C13C).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated decorative particles
                for (int i = 0; i < 5; i++)
                  Positioned(
                    top: (screenHeight * (0.1 + (i * 0.18))),
                    left: (screenWidth * (0.1 + ((i % 3) * 0.3))),
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.6,
                      child: Transform.translate(
                        offset: Offset(
                          math.sin(_rotateController.value * 2 * math.pi + i) * 10,
                          math.cos(_rotateController.value * 2 * math.pi + i * 2) * 10,
                        ),
                        child: Container(
                          width: 12 + (i * 5),
                          height: 12 + (i * 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB8C13C).withOpacity(0.7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFB8C13C).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Main content in center
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animations
                      Transform.scale(
                        scale: _scaleAnimation.value * _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB8C13C).withOpacity(0.3 * _fadeAnimation.value),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Image.asset(
                              'assets/images/jojocart_logo.png',
                              height: 140,
                              width: 140,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Animated text appearance
                      Transform.translate(
                        offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: const Text(
                            "jojocart",
                            style: TextStyle(
                              color: Color(0xFF454545),
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Transform.translate(
                        offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: const Text(
                            "online shop delivered",
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Custom animated loading indicator
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomLoadingIndicator(controller: _rotateController),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom loading indicator with gift box animation
class CustomLoadingIndicator extends StatelessWidget {
  final AnimationController controller;

  const CustomLoadingIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LoadingPainter(animationValue: controller.value),
          size: const Size(50, 50),
        );
      },
    );
  }
}

class LoadingPainter extends CustomPainter {
  final double animationValue;

  LoadingPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFB8C13C)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw animated arc
    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * (0.05 + (animationValue * 0.9));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw small gift box icon in the center
    paint.style = PaintingStyle.fill;

    // Box base
    final boxRect = Rect.fromCenter(
      center: center,
      width: radius * 0.8,
      height: radius * 0.8,
    );
    canvas.drawRect(boxRect, paint);

    // Box ribbon
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - 2,
        center.dy - radius * 0.4,
        4,
        radius * 0.8,
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 0.4,
        center.dy - 2,
        radius * 0.8,
        4,
      ),
      paint,
    );

    // Box lid
    paint.color = const Color(0xFFB8C13C);
    final boxLidPath = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy - radius * 0.4)
      ..lineTo(center.dx + radius * 0.5, center.dy - radius * 0.4)
      ..lineTo(center.dx + radius * 0.4, center.dy - radius * 0.5)
      ..lineTo(center.dx - radius * 0.4, center.dy - radius * 0.5)
      ..close();

    canvas.drawPath(boxLidPath, paint);
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

