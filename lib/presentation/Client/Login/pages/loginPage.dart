import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:routesyncui/presentation/Client/Login/pages/signuppage.dart';
import 'package:routesyncui/presentation/Widgets/CustomHeaderLogin.dart';
import 'package:http/http.dart ' as http;
import '../../../../infrastructure/endpoints/auth/auth_service.dart';
import '../../DashBoard/dashboard.dart';
import 'package:routesyncui/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> login() async {
    if (!mounted)
      return; // Ensure widget still exists before starting async operation.

    setState(() {
      _isLoading = true;
    });

    bool isLoggedIn = false; // Handle potential errors in login service.
    try {
      isLoggedIn = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      print(e); // Log the actual error for debugging.
    }

    // Check again if the widget is mounted before using context or updating UI.
    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }

    if (!mounted) return; // Check to prevent unnecessary state updates.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with shadow and rounded edges
          CustomHeader(
            imagePath: 'assets/images/bg.jpg',
            overlayText: 'RouteSync',
            height: 380, // You can specify the height here
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 400),
                child: Text(
                  'Hi, Welcome Back! 👋',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  children: [
                    Forms(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool? isChecked = false;
  bool rememberMe = false;

  Widget Forms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email', // Label above the text field
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 5), // Space between label and text field
        SizedBox(
          height: 50,
          child: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: 'example@gmail.com',
            ),
          ),
        ),
        const SizedBox(height: 8), // Space between the two text fields
        const Text(
          'Password', // Label for the second text field
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: 'enter your password',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // Shrinks padding
                    ),
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Manrop',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(width: 80),
            // "Forgot Password?" link
            GestureDetector(
              onTap: () {
                // Add your "Forgot Password?" functionality here
                print("Forgot Password tapped");
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: login,
            child: Container(
              width: double.infinity,
              height: 45,
              color: const Color(0xFF0E64D2),
              child: const Center(
                  child: Text(
                'Log in',
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
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.black45, // Set color for the line
                thickness: 1, // Set thickness for the line
                endIndent: 10, // Spacing between line and text
              ),
            ),
            Text(
              'Or With',
              style: TextStyle(
                  color: Colors.black87, // Set color for the text
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 18 // Adjust weight if needed
                  ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black45, // Set color for the line
                thickness: 1, // Set thickness for the line
                indent: 10, // Spacing between line and text
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black, // Border color
              width: 0.7, // Border width
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/icons/google_icon.png',
              //   width: 30,
              // ),
              // const SizedBox(width: 3),
              // const Text(
              //   'Login with Google',
              //   style: TextStyle(
              //     color: Colors.black54,
              //     fontFamily: 'Poppins',
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(width: 3),
              const Text(
                'Debug Login',
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account ?",
              style: TextStyle(
                  fontFamily: 'Manrop',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Signuppage()),
                //   );
              },
              child: const Text(
                "Sign up",
                style: TextStyle(
                  fontFamily: 'Manrop',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0E64D2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
