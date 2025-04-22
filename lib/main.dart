import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:routesyncui/presentation/Client/DashBoard/dashboard.dart';
import 'package:routesyncui/infrastructure/mainLoginPage.dart';
import 'package:routesyncui/presentation/Admin/AdminDashboard/adminDashboard.dart';
import 'package:routesyncui/presentation/Client/LandingPage/landingpage.dart';
import 'package:routesyncui/presentation/Client/Login/pages/loginPage.dart';
import 'package:routesyncui/presentation/Client/Login/pages/signuppage.dart';
import 'package:routesyncui/presentation/Client/MapPage/mapview.dart';

import 'presentation/DriverSide/Dashboard/driver_Dashbaord.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppLoader());
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  Future<String?> _getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        debugPrint("Token found: $token");
        return token;
      } else {
        debugPrint("No valid token found.");
        return null;
      }
    } catch (e) {
      debugPrint("Error retrieving token: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          debugPrint("Token not found or error occurred.");
          return const MyApp(token: null); // Force login page
        }

        return MyApp(token: snapshot.data);
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          (token != null && token!.isNotEmpty) ? Dashboard() : mainLoginPage(),
      routes: {
        '/LandingPage': (context) => LandingPage(),
        '/Dashboard': (context) => Dashboard(),
        //  '/AdminDashboard': (context) => Admindashboard(),
        '/LoginPage': (context) => LoginPage(),
        '/MapView': (context) => MapView(),
        '/MainLoginPage': (context) => mainLoginPage(),
        //  '/DriverDashboard': (context) => DriverDashboard(),
      },
    );
  }
}
