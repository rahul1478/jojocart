import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Title dropdown values
  String _selectedTitle = 'Mr';
  final List<String> _titleOptions = ['Mr', 'Mrs', 'Ms', 'Dr', 'Prof'];

  // Country code
  String _countryCode = '+91';

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Loading states
  bool _isLoading = false;
  bool _isGoogleLoading = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

                      const SizedBox(height: 30),

                      // Welcome text
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Join JojoCart and start gifting!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Name field with title dropdown
                      Row(
                        children: [
                          // Title dropdown
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedTitle,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                              items: _titleOptions.map((String title) {
                                return DropdownMenuItem<String>(
                                  value: title,
                                  child: Text(
                                    title,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTitle = newValue!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Name field
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                prefixIcon: const Icon(Icons.person_outline),
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Email field
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

                      // Mobile number field with country code
                      Row(
                        children: [
                          // Country code picker
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CountryCodePicker(
                              onChanged: (country) {
                                setState(() {
                                  _countryCode = country.dialCode!;
                                });
                              },
                              initialSelection: 'IN',
                              favorite: const ['+91', 'IN', '+1', 'US'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Mobile number field
                          Expanded(
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                hintText: 'Enter mobile number',
                                prefixIcon: const Icon(Icons.phone_outlined),
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
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
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
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
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
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
                      ),

                      const SizedBox(height: 20),

                      // Sign Up button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF8BAF47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

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

                      // Google signup button
                      OutlinedButton.icon(
                        onPressed: _isGoogleLoading ? null : _handleGoogleSignUp,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _isGoogleLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Image.network(
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

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(); // Go back to login screen
                            },
                            child: Text(
                              'Sign In',
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
                        'By creating an account, you agree to our Terms & Conditions and Privacy Policy',
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
            'assets/images/jojocart_logo.png',
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

  // Handle regular sign up
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _registerUser(
          address: "",
          city: "",
          country: "",
          countryCode: _countryCode,
          dateOfAnniversary: "",
          dob: "",
          email: _emailController.text.trim(),
          gender: "NA",
          isExistingUser: false,
          mobile: _mobileController.text.trim(),
          name: _nameController.text.trim(),
          googleToken: "",
          loginType: "Email",
          password: _passwordController.text,
          pincode: "",
          title: _selectedTitle,
          username: _nameController.text.trim(),
        );
      } catch (e) {
        print('Sign up error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle Google sign up
  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final userCredential = await _signInWithGoogle();
      if (userCredential != null) {
        final user = userCredential.user;
        final token = await user?.getIdToken();

        if (user != null && token != null) {
          await _registerUser(
            address: "",
            city: "",
            country: "",
            countryCode: "+91",
            dateOfAnniversary: "",
            dob: "",
            email: user.email ?? "",
            gender: "NA",
            isExistingUser: !(userCredential.additionalUserInfo?.isNewUser ?? false),
            mobile: user.phoneNumber ?? "",
            name: user.displayName ?? "",
            googleToken: token,
            loginType: "Google",
            password: token,
            pincode: "",
            title: "Mr",
            username: user.displayName ?? "",
          );
        }
      }
    } catch (e) {
      print('Google sign up error: $e');
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  // Google Sign In
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In error: $e");
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

  // Register user API call
  Future<void> _registerUser({
    required String address,
    required String city,
    required String country,
    required String countryCode,
    required String dateOfAnniversary,
    required String dob,
    required String email,
    required String gender,
    required bool isExistingUser,
    required String mobile,
    required String name,
    required String googleToken,
    required String loginType,
    required String password,
    required String pincode,
    required String title,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://kingsbakerbackend-production.up.railway.app/api/user/createUser'), // Replace with your actual API endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_details': {
          'address': address,
          'city': city,
          'country': country,
          'countryCode': countryCode,
          'dateOfAnniversary': dateOfAnniversary,
          'dob': dob,
          'email': email,
          'gender': gender,
          'isExistingUser': isExistingUser,
          'mobile': mobile,
          'name': name,
          'google_token': googleToken,
          'login_type': loginType,
          'password': password,
          'pincode': pincode,
          'title': title,
          'username': username,
        }}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(responseData.toString());

        Future.delayed(Duration.zero, () {
          Get.snackbar(
            'Success',
            responseData['message'] ?? 'Account created successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary,
            duration: Duration(seconds: 3),
          );
        });

        // Navigate back to login or home screen
        Get.back(); // Goes back to login screen

      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Registration failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print('Registration API error: $e');
      Get.snackbar(
        'Error',
        'Network error. Please check your connection and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
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