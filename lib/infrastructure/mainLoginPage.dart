import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:routesyncui/infrastructure/endpoints/auth/auth_service.dart';
import 'package:routesyncui/presentation/Client/Login/pages/signuppage.dart';
import 'package:routesyncui/presentation/Widgets/CustomHeaderLogin.dart';
import 'package:flutter_svg/svg.dart';
import '../presentation/Client/DashBoard/dashboard.dart';
import '../presentation/Widgets/CustomLoginButton.dart';

class mainLoginPage extends StatefulWidget {
  const mainLoginPage({super.key});

  @override
  State<mainLoginPage> createState() => _mainLoginPageState();
}

class _mainLoginPageState extends State<mainLoginPage> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              SizedBox(
                height: 25,
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
        SizedBox(
          height: 20,
        ),
        LoginButton(
          text: "Login as Student",
          route: "/LoginPage",
        ),
        SizedBox(
          height: 20,
        ),
        LoginButton(
          text: "Login as Driver",
          route: "/AdminDashboard",
        ),
        SizedBox(
          height: 20,
        ),
        LoginButton(
          text: "Login as Admin",
          route: "/AdminDashboard",
        )
      ],
    );
  }
}
