

import 'package:flutter/material.dart';
import 'package:routesyncui/auth/auth_service.dart';
import 'package:routesyncui/presentation/Login/pages/loginPage.dart';
import 'package:routesyncui/presentation/Login/widgets/CustomHeaderLogin.dart';



class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  // Get auth services
  final authService = AuthService();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _batchController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Signup button pressed
  Future<void> signUp() async {
    // Prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Check for password match
    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password doesn't match")));
      }
      return;
    }

    // Attempt signup
    try {
      // Sign up with email and password
      await authService.signupWithEmailPassword(email, password);

      // After successful signup, create user details
      await authService.createUserDetails(
        _nameController.text,
        _rollNoController.text,
        _batchController.text,
        _phoneNumberController.text,
        email,
      );

      // Clear the text fields after successful signup
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();
      _rollNoController.clear();
      _batchController.clear();
      _phoneNumberController.clear();

      // Navigate to login page after successful signup
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with shadow and rounded edges, positioned at the top

          // SingleChildScrollView that allows scrolling of form fields under the background
          SingleChildScrollView(
            child: Column(
              children: [
                // Add padding to push content below the background image
                const SizedBox(height: 250), // Adjust this height as needed
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Start tracking your college bus with ease!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      wordSpacing: 0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Forms(),
              ],
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomHeader(
                imagePath: 'assets/images/bg.jpg',
                overlayText: 'RouteSync',
                height: 290, // You can specify the height here
              )),
        ],
      ),
    );
  }

  Widget Forms() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5), // Space between label and text field
          // Name TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter Your Name',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Roll No TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter Your Roll No',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Batch TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _batchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter Your Batch (e.g., 2021)',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Phone Number TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter Your Phone Number',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Email TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter Your Email',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Password TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Enter your Password',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Confirm Password TextField
          SizedBox(
            height: 50,
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Re-enter Your Password',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Signup Button
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: signUp,
              child: Container(
                width: 350,
                height: 45,
                color: const Color(0xFF0E64D2),
                child: const Center(
                    child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
