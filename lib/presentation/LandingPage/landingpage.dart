import 'package:flutter/material.dart';
import 'package:routesyncui/presentation/Login/pages/loginPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingpageState();
}

class _LandingpageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with shadow and rounded edges
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(39),
                  bottomRight: Radius.circular(39),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 7,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(39),
                  bottomRight: Radius.circular(39),
                ),
                child: Image.asset(
                  'assets/images/bg.jpg',
                  height: screenHeight * 0.86, // 70% of screen height
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Black overlay on the image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(39),
              bottomRight: Radius.circular(39),
            ),
            child: Container(
              height: screenHeight * 0.86, // 70% overlay height
              width: screenWidth,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Text overlay positioned above the bottom
          Positioned(
            bottom: screenHeight * 0.5,
            left: 20,
            right: 20,
            child: const Text(
              'RouteSync',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w700,
                fontFamily: 'AirbnbCereal',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Welcome text and "next" button at the bottom
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Welcome to RouteSync',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.06, // Scalable text size
                    fontWeight: FontWeight.w600,
                    fontFamily: 'AirbnbCereal',
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Your seamless connection to real-time\ncollege bus tracking and updates.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.037, // Scalable text size
                          fontWeight: FontWeight.w400,
                          fontFamily: 'AirbnbCereal',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Wrap Transform widget with GestureDetector for navigation
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Transform.translate(
                      offset: Offset(
                          1, -screenHeight * 0.018), // Responsive upward offset
                      child: Image.asset(
                        'assets/icons/next_page.png',
                        height: screenHeight * 0.06, // Scalable icon size
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: screenHeight * 0.02), // Scalable vertical spacing
            ],
          )
        ],
      ),
    );
  }
}
