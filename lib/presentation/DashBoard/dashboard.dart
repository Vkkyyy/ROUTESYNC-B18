import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:routesyncui/presentation/MapPage/mapview.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../Login/widgets/CustomHeaderLogin.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String _name = "Loading...";
  String _batch = "";
  bool _isLoading = false;
  // Default user name shown initially

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchUserBatch();
  }

  // Fetch the user's name from Supabase using a query
  // Future<void> _fetchUserName() async {
  //   try {
  //     // Step 1: Get the authenticated user's ID
  //     final userId = _supabase.auth.currentUser?.id ?? ''; // Get user ID

  //     if (userId.isEmpty) {
  //       setState(() {
  //         _name = "User not authenticated"; // Handle unauthenticated state
  //       });
  //       return;
  //     }

  //     // Step 2: Query the users table with the user ID filter
  //     final data = await _supabase
  //         .from('user_details') // Your table name
  //         .select('name') // Specify the column to select
  //         // Filter for the authenticated user
  //         .single(); // Get a single record (this assumes 'id' is unique)

  //     // Step 3: Update the state with the fetched name
  //     if (data != null) {
  //       setState(() {
  //         _name = data['name']; // Assign the user's name to the _name variable
  //       });
  //     } else {
  //       setState(() {
  //         _name = "Name not found"; // Handle empty data
  //       });
  //     }
  //   } catch (error) {
  //     // Handle errors such as connectivity issues or query failures
  //     setState(() {
  //       _name = "Failed to load name";
  //     });
  //     debugPrint("Error fetching user name: $error");
  //   }
  // }
  Future<void> _fetchUserName() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final userId = _supabase.auth.currentUser?.id ?? ''; // Get user ID

      if (userId.isEmpty) {
        setState(() {
          _name = "User not authenticated";
          _isLoading = false; // Stop loading
        });
        return;
      }

      final data = await _supabase.from('user_details').select('name').single();

      if (data != null) {
        setState(() {
          _name = data['name'];
          _isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          _name = "Name not found";
          _isLoading = false; // Stop loading
        });
      }
    } catch (error) {
      setState(() {
        _name = "Failed to load name";
        _isLoading = false; // Stop loading
      });
      debugPrint("Error fetching user name: $error");
    }
  }

  // Fetch the user's name from Supabase using a query
  Future<void> _fetchUserBatch() async {
    try {
      // Step 1: Get the authenticated user's ID
      final userId = _supabase.auth.currentUser?.id ?? ''; // Get user ID

      if (userId.isEmpty) {
        setState(() {
          _name = "User not authenticated"; // Handle unauthenticated state
        });
        return;
      }

      // Step 2: Query the users table with the user ID filter
      final data = await _supabase
          .from('user_details') // Your table name
          .select('batch') // Specify the column to select
          // Filter for the authenticated user
          .single(); // Get a single record (this assumes 'id' is unique)

      // Step 3: Update the state with the fetched name
      if (data != null) {
        setState(() {
          _batch =
              data['batch']; // Assign the user's name to the _name variable
        });
      } else {
        setState(() {
          _batch = "batch not found"; // Handle empty data
        });
      }
    } catch (error) {
      // Handle errors such as connectivity issues or query failures
      setState(() {
        _batch = "Failed to load batch";
      });
      debugPrint("Error fetching user batch: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with shadow and rounded edges
          CustomHeader(
            imagePath: 'assets/images/bg.jpg',

            height: 330, overlayText: '', // You can specify the height here
          ),
          // Text overlay positioned above the bottom
          const Positioned(
            top: 28,
            left: 18,
            right: 5,
            child: Text(
              'RouteSync',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: "AirbnbCereal",
              ),
              // textAlign: TextAlign.center,
            ),
          ),
          Positioned(
              top: 32,
              right: 18,
              child: Image.asset(
                'assets/icons/scanner.png',
                width: 40,
              )),
          const Positioned(
            top: 100,
            left: 18,
            right: 5,
            child: Text(
              'Good Morning,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          // Positioned(
          //   top: 140,
          //   left: 18,
          //   right: 5,
          //   child: Text(
          //     _name, // Display the dynamically fetched user name
          //     style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 35,
          //       fontWeight: FontWeight.w800,
          //       fontFamily: 'Poppins',
          //     ),
          //   ),
          // ),

          Positioned(
            top: 165,
            left: 18,
            right: 5,
            child: Text(
              "Route Details", // Display the dynamically fetched user name
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const Positioned(
            top: 205,
            left: 18,
            right: 5,
            child: Text(
              'Bus No: 32\nOn Moving 🚌 | 🟢',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w200,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          Positioned(
            top: 370,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Soft shadow color
                        blurRadius: 10, // Smoothness of the shadow
                        spreadRadius: 10, // Extent of the shadow
                        offset: Offset(0, 5), // Shadow position below the card
                      ),
                    ],
                  ),
                  width: 160,
                  height: 190,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Add your widget content here (text, icons, etc.)
                        Image.asset(
                          'assets/images/qrcode.png',
                          width: 110,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Bus Pass", // Display the dynamically fetched user name
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          "Pass ID: 20182", // Display the dynamically fetched user name
                          style: const TextStyle(
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
                SizedBox(
                  width: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Soft shadow color
                        blurRadius: 10, // Smoothness of the shadow
                        spreadRadius: 10, // Extent of the shadow
                        offset: Offset(0, 5), // Shadow position below the card
                      ),
                    ],
                  ),
                  width: 195,
                  height: 190,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: _isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Add your widget content here (text, icons, etc.)
                              CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    AssetImage('assets/icons/profile.jpg'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _name, // Display the dynamically fetched user name
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),

                              Text(
                                "Batch: $_batch", // Display the dynamically fetched user name
                                style: const TextStyle(
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
              ],
            ),
          ),
          Positioned(
            top: 578,
            left: 20,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapView()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), // Soft shadow color
                              blurRadius: 10, // Smoothness of the shadow
                              spreadRadius: 10, // Extent of the shadow
                              offset: Offset(
                                  0, 5), // Shadow position below the card
                            ),
                          ],
                        ),
                        width: 370,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              15), // Ensure the blur respects border
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaX: 1, sigmaY: 1), // Blur effect
                            child: Image.asset(
                              'assets/images/mapviewhover.png', // Replace with your asset image path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 370,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(
                              0.4), // Overlay for better text contrast
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
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Image.asset(
                                'assets/icons/map.png',
                                width: 80,
                              ), // Removed Positioned here
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Soft shadow color
                        blurRadius: 10, // Smoothness of the shadow
                        spreadRadius: 10, // Extent of the shadow
                        offset: Offset(0, 5), // Shadow position below the card
                      ),
                    ],
                  ),
                  width: 230,
                  height: 110,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 5, right: 5, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add your widget content here (text, icons, etc.)
                        Text(
                          "Route Details:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text("Route No: 32\nPalladam-NGPiTech",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            )),
                        Text("Click here for more details",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Soft shadow color
                        blurRadius: 10, // Smoothness of the shadow
                        spreadRadius: 10, // Extent of the shadow
                        offset: Offset(0, 5), // Shadow position below the card
                      ),
                    ],
                  ),
                  width: 125,
                  height: 110,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Add your widget content here (text, icons, etc.)
                        //  CalendarScreen()

                        Image.asset(
                          'assets/icons/notificationbell.png',
                          width: 50,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Messages",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container()
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
