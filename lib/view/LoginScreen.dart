import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jojocart_mobile/view/SignUpScreen.dart';
import 'dart:math' as math;
import '../controller/AuthController.dart';
import '../theme/appTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // GetX controller
  final AuthController authController = Get.put(AuthController());

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Logo
                      _buildLogo(),

                      const SizedBox(height: 40),

                      // Welcome text
                      Text(
                        'Welcome to JojoCart',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Send Gifts Anywhere, Everywhere!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Email field with validation
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password field with validation
                      Obx(() => TextFormField(
                        controller: _passwordController,
                        obscureText: !authController.isPasswordVisible.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: authController.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                      )),

                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password screen
                            Get.toNamed('/forgot-password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login button with GetX
                      Obx(() => ElevatedButton(
                        onPressed: authController.isLoading.value ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF8BAF47), // Olive green from the example
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: authController.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),

                      const SizedBox(height: 20),

                      // OR divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: Colors.grey[400]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey[400]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google login button
                      OutlinedButton.icon(
                        onPressed: () async {
                          final userCredential = await signInWithGoogle();
                          if (userCredential != null) {
                            Get.snackbar(
                              'Success',
                             '${userCredential.user?.displayName} Login successful!',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Get.theme.primaryColor,
                              colorText: Get.theme.colorScheme.onPrimary,
                            );
                            // Successfully signed in
                            print("Logged in as: ${userCredential.user?.displayName}");
                            Navigator.pop(context);
                            // Navigate or show success
                          } else {
                            // Login failed or cancelled
                            print("Google Sign-In cancelled or failed.");
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                          height: 24,
                          width: 24,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(SignUpScreen());
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Terms and conditions
                      Text(
                        'By continuing, you agree to our Terms & Conditions and Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); // ✅ Force showing account picker

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the login
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, st) {
      print("Google Sign-In error: $e");
      print("Stacktrace: $st");
      Get.snackbar(
        'Error',
        'Google Sign-In failed. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return null;
    }
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/jojocart_logo.png', // 🔥 Your logo image path
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(animation: _animation.value),
          child: Container(),
        );
      },
    );
  }

  // Updated login handler
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Navigate to home page after successful login
        Navigator.pop(context);
      }
    }
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;

  BackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    // Base background color
    Paint basePaint = Paint()
      ..color = const Color(0xFFF6F7FB);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), basePaint);

    // First bubble
    Paint bubblePaint1 = Paint()
      ..color = const Color(0xFFFFCACC).withOpacity(0.3);

    double centerX1 = width * 0.3;
    double centerY1 = height * 0.1;
    double radius1 = width * 0.5;

    double offset1 = math.sin(animation * math.pi * 2) * 20;

    canvas.drawCircle(
      Offset(centerX1 + offset1, centerY1),
      radius1,
      bubblePaint1,
    );

    // Second bubble
    Paint bubblePaint2 = Paint()
      ..color = const Color(0xFF8BAF47).withOpacity(0.2);

    double centerX2 = width * 0.8;
    double centerY2 = height * 0.15;
    double radius2 = width * 0.4;

    double offset2 = math.cos(animation * math.pi * 2) * 15;

    canvas.drawCircle(
      Offset(centerX2, centerY2 + offset2),
      radius2,
      bubblePaint2,
    );

    // Third bubble
    Paint bubblePaint3 = Paint()
      ..color = const Color(0xFFFFCACC).withOpacity(0.2);

    double centerX3 = width * 0.2;
    double centerY3 = height * 0.85;
    double radius3 = width * 0.35;

    double offset3 = math.sin((animation + 0.5) * math.pi * 2) * 25;

    canvas.drawCircle(
      Offset(centerX3 + offset3, centerY3),
      radius3,
      bubblePaint3,
    );

    // Fourth bubble - accent color
    Paint bubblePaint4 = Paint()
      ..color = const Color(0xFF8BAF47).withOpacity(0.15);

    double centerX4 = width * 0.7;
    double centerY4 = height * 0.7;
    double radius4 = width * 0.45;

    double offset4 = math.cos((animation + 0.5) * math.pi * 2) * 20;

    canvas.drawCircle(
      Offset(centerX4, centerY4 + offset4),
      radius4,
      bubblePaint4,
    );
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}