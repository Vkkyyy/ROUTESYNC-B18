import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String imagePath;
  final String overlayText;
  final double height; // New parameter for height

  const CustomHeader({
    super.key,
    required this.imagePath,
    required this.overlayText,
    required this.height, // Include height in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                imagePath,
                height: height, // Use the passed height parameter here
                fit: BoxFit.fitHeight,
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
            height: height, // Use the same height parameter here
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        // Text overlay positioned above the bottom
        Positioned(
          bottom: 60,
          left: 20,
          right: 20,
          child: Text(
            overlayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w700,
              fontFamily: 'AirbnbCereal',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
