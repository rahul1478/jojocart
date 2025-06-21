import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var user = Rxn<User>();
  var authToken = ''.obs;

  // API Base URL - Replace with your actual API URL
  static const String baseUrl = 'https://kingsbakerbackend-production.up.railway.app/api';

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? userData = prefs.getString('user_data');

      if (token != null && userData != null) {
        authToken.value = token;
        user.value = User.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (!_validateInputs(email, password)) {
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/login'), // Replace with your actual login endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Parse the response
        final userData = responseData['data'];
        final token = userData['authcode'];

        // Create user object
        user.value = User(
          id: userData['_id'],
          name: userData['user'],
          email: userData['email'],
          deliveryAddress: userData['delivery_address'],
          role: userData['role'],
        );

        authToken.value = token;

        // Save to local storage
        await _saveAuthData(token, user.value!,true);

        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );

        return true;
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Login Failed',
          errorData['message'] ?? 'Invalid credentials',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      print('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Validate input fields
  bool _validateInputs(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    return true;
  }

  // Save authentication data to local storage
  Future<void> _saveAuthData(String token, User userData,bool isLoggedIn) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(userData.toJson()));
      await prefs.setBool('isLoggedIn', isLoggedIn);
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.remove('isLoggedIn');

      user.value = null;
      authToken.value = '';

      Get.offAllNamed('/login'); // Navigate to login screen
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => user.value != null && authToken.value.isNotEmpty;
}

// User model class
class User {
  final String id;
  final String name;
  final String email;
  final String deliveryAddress;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.deliveryAddress,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'deliveryAddress': deliveryAddress,
      'role': role,
    };
  }
}