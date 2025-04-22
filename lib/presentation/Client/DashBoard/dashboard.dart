import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../infrastructure/endpoints/student/fetch_student_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _name;
  String? _rollNo;
  String? _busStop;
  String _batch = "";
  bool _isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? studentData;

  @override
  void initState() {
    super.initState();
    _fetchStudent();
  }

  Future<void> _fetchStudent() async {
    setState(() {
      _isLoading = true; // Set the loading flag to true before starting
    });

    final service = StudentService();
    try {
      final data = await service.fetchStudentDetails();

      if (data != null && mounted) {
        setState(() {
          studentData = data;
          errorMessage = null; // Clear any error messages, if present
          _isLoading = false; // Set the loading state to false
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Failed to fetch student details.";
          _isLoading = false; // Set the loading state to false
        });
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove token
    await prefs.remove('token');
    print("✅ User logged out successfully!");

    // Navigate to Login Screen
    Navigator.pushReplacementNamed(context,
        '/MainLoginPage'); // Change '/login' to your actual login route
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Adjust height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'RouteSync',
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => logout(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/icons/scanner.png',
                  width: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.025),
        children: [
          // Greeting Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Background color
              borderRadius:
                  BorderRadius.circular(12), // Optional rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "Route Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoading
                      ? 'Loading...'
                      : errorMessage ?? 'Bus Stop: \nOn Moving 🚌 | 🟢',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Space after the container

          // Pass and Profile Section
          Row(
            children: [
              // Bus Pass Card
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/qrcode.png',
                          width: screenWidth * 0.25,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Bus Pass",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.02, // Dynamic scaling
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Pass ID: 20182",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Profile Information Card
              Expanded(
                flex: screenHeight > 600 ? 4 : 4, // Responsive sizing
                child: Container(
                  width: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (studentData != null)
                            ? Column(
                                children: [
                                  CircleAvatar(
                                    radius:
                                        screenWidth * 0.12, // Responsive size
                                    backgroundImage: const AssetImage(
                                      'assets/icons/profile.jpg',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${studentData!['name']}", // Safe access with a null check above
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${studentData!['roll_no']}", // Safe access
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'No student data available',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screenHeight * 0.02,
                                ),
                              ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),

          // Live Location Card
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/MapView');
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: Image.asset(
                        'assets/images/mapviewhover.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Live Location of\nthe bus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/icons/map.png',
                          width: screenWidth * 0.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Route Details and Messages Section
          Row(
            children: [
              // Route Details Card
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Route Details:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Route No: 32\nPalladam-NGPiTech",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Click here for more details",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Messages Card
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Image.asset(
                          'assets/icons/notificationbell.png',
                          width: screenWidth * 0.15, // Responsive size
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Messages",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.015,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
