import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class MyDraggablePage extends StatefulWidget {
  const MyDraggablePage();

  @override
  State<MyDraggablePage> createState() => _MyDraggablePageState();
}

class _MyDraggablePageState extends State<MyDraggablePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String _name = "Loading...";
  String _mail = "Loading...";
  String _phNumber = "Loading...";
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  bool _isCentered = false; // Track profile position

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSizeChanged);
    _fetchUserName();
    _fetchUserMail();
    _fetchUserPhNumber();
  }

  @override
  void dispose() {
    _controller.removeListener(_onSizeChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSizeChanged() {
    final isCentered = _controller.size > 0.5;
    if (_isCentered != isCentered) {
      setState(() {
        _isCentered = isCentered;
      });
    }
  }

  void _expandToSnapSize() {
    _controller.animateTo(
      0.88,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void _collapse() {
    _controller.animateTo(
      0.1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget createInfoTile({required String title, required String img}) {
    return Container(
      width: 380,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 8),
            child: SizedBox(
              height: 35,
              child: Image(
                image: AssetImage(img),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'AirbnbCereal',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUserName() async {
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
          .select('name') // Specify the column to select
          // Filter for the authenticated user
          .single(); // Get a single record (this assumes 'id' is unique)

      // Step 3: Update the state with the fetched name
      if (data != null) {
        setState(() {
          _name = data['name']; // Assign the user's name to the _name variable
        });
      } else {
        setState(() {
          _name = "Name not found"; // Handle empty data
        });
      }
    } catch (error) {
      // Handle errors such as connectivity issues or query failures
      setState(() {
        _name = "Failed to load name";
      });
      debugPrint("Error fetching user name: $error");
    }
  }

  Future<void> _fetchUserMail() async {
    try {
      // Step 1: Get the authenticated user's ID
      final userId = _supabase.auth.currentUser?.id ?? ''; // Get user ID

      if (userId.isEmpty) {
        setState(() {
          _mail = "User not authenticated"; // Handle unauthenticated state
        });
        return;
      }

      // Step 2: Query the users table with the user ID filter
      final data = await _supabase
          .from('user_details') // Your table name
          .select('email') // Specify the column to select
          // Filter for the authenticated user
          .single(); // Get a single record (this assumes 'id' is unique)

      // Step 3: Update the state with the fetched name
      if (data != null) {
        setState(() {
          _mail = data['email']; // Assign the user's name to the _name variable
        });
      } else {
        setState(() {
          _mail = "mail not found"; // Handle empty data
        });
      }
    } catch (error) {
      // Handle errors such as connectivity issues or query failures
      setState(() {
        _mail = "Failed to load mail";
      });
      debugPrint("Error fetching mail: $error");
    }
  }

  Future<void> _fetchUserPhNumber() async {
    try {
      // Step 1: Get the authenticated user's ID
      final userId = _supabase.auth.currentUser?.id ?? ''; // Get user ID

      if (userId.isEmpty) {
        setState(() {
          _phNumber = "User not authenticated"; // Handle unauthenticated state
        });
        return;
      }

      // Step 2: Query the users table with the user ID filter
      final data = await _supabase
          .from('user_details') // Your table name
          .select('phone_number') // Specify the column to select
          // Filter for the authenticated user
          .single(); // Get a single record (this assumes 'id' is unique)

      // Step 3: Update the state with the fetched name
      if (data != null) {
        setState(() {
          _phNumber = data[
              'phone_number']; // Assign the user's name to the _name variable
        });
      } else {
        setState(() {
          _phNumber = "phone_number not found"; // Handle empty data
        });
      }
    } catch (error) {
      // Handle errors such as connectivity issues or query failures
      setState(() {
        _phNumber = "Failed to load phone_number";
      });
      debugPrint("Error fetching phone_number: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      maxChildSize: 0.88,
      minChildSize: 0.1,
      expand: true,
      snap: true,
      snapSizes: const [0.88],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: _isCentered
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // Background color of the TextField
                                        borderRadius: BorderRadius.circular(
                                            8), // Same as TextField border
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.1), // Shadow color
                                            blurRadius:
                                                10, // Smoothness of the shadow
                                            spreadRadius:
                                                2, // Extent of the shadow
                                            offset: Offset(
                                                0, 4), // Position of the shadow
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Search Maps',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'AirbnbCereal',
                                            fontWeight: FontWeight.w300,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide
                                                .none, // No visible border
                                          ),
                                          fillColor: Colors
                                              .transparent, // Background handled by Container
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  width: 330,
                                  height: 175,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(
                                            'assets/icons/profile.jpg'),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        _name, // Display the dynamically fetched user name
                                        style: const TextStyle(
                                            fontFamily: 'AirbnbCereal',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '$_mail | +91 $_phNumber',
                                        style: TextStyle(
                                            fontFamily: 'AirbnbCereal',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      // Text(
                                      //   'vaishak@drngpit.ac.in | +91 9898989898',
                                      //   style: TextStyle(
                                      //       fontFamily: 'AirbnbCereal',
                                      //       fontSize: 13,
                                      //       fontWeight: FontWeight.w200),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 300,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    createInfoTile(
                                      title: 'Personal Info',
                                      img: 'assets/icons/personalinfo.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    createInfoTile(
                                      title: 'Notifications',
                                      img: 'assets/icons/notificationbell.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    createInfoTile(
                                      title: 'Payment Portal',
                                      img: 'assets/icons/cash.png',
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      width: 300,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    createInfoTile(
                                      title: 'My Route',
                                      img: 'assets/icons/myroute.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    createInfoTile(
                                      title: 'Get New Route',
                                      img: 'assets/icons/newroute.png',
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      width: 300,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    createInfoTile(
                                      title: 'Settings',
                                      img: 'assets/icons/settings.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    createInfoTile(
                                      title: 'Help & Support',
                                      img: 'assets/icons/help.png',
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    createInfoTile(
                                      title: 'About Us',
                                      img: 'assets/icons/about.png',
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'RouteSync',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'AirbnbCereal',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xF65B5B5B),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      '© 2024 RouteSync, Inc.•Site map•Community guidelines - Terms of service',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontFamily: 'AirbnbCereal',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xF65B5B5B),
                                      ),
                                    )
                                  ],
                                ) // Spacer between profile and navigation bar
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.1), // Shadow color
                                              blurRadius:
                                                  10, // Blur radius for the shadow
                                              spreadRadius:
                                                  2, // Spread radius for the shadow
                                              offset: Offset(
                                                  0, 4), // Shadow position
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Search Maps',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'AirbnbCereal',
                                              fontWeight: FontWeight.w300,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                            fillColor: Colors
                                                .transparent, // Keep transparent as the Container has the background color
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/icons/profile.jpg'),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SliverList.list(
                children: [],
              ),
            ],
          ),
        );
      },
    );
  }
}
