import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:routesyncui/presentation/ProfilePage/ProfilePage.dart';

import 'dart:convert';

import 'dart:ui' as ui;

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

// Add permission_handler package

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;
  PolylineAnnotationManager? polylineAnnotationManager;

  /// Resize image function for PointAnnotation
  Future<Uint8List> loadAndResizeImage(
      String assetPath, int width, int height) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedBytes = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return resizedBytes!.buffer.asUint8List();
  }

  /// Fetch directions from Mapbox Directions API
  // Future<List<List<double>>> fetchDirections() async {
  //   const String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
  //       '77.06744400748192,11.005328146497973;'
  //       ' 77.0270989293021,11.004680942091724;'
  //       '77.02106933847415,11.026375406184485;'
  //       '77.03728727396867,11.061035762879257'
  //       '?alternatives=false&geometries=polyline&language=en&overview=full&steps=true'
  //       '&access_token=pk.eyJ1IjoidmFpc2hha3ZsIiwiYSI6ImNsenBxaGY5YzBtcjYycXMzYnRqOHUwd28ifQ.ytNFaZ4ZbCHy1KBV3fmR3A';

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final decoded = json.decode(response.body);
  //       final String polyline =
  //           decoded['routes'][0]['geometry']; // Grab polyline data
  //       return decodePolyline(
  //           polyline); // Decode and return list of coordinates
  //     } else {
  //       throw Exception('Failed to fetch directions: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching directions: $e');
  //     rethrow;
  //   }
  // }
  /// Updated `fetchDirections` function to also fetch duration
  Future<Map<String, dynamic>> fetchDirections() async {
    const String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '77.06744400748192,11.005328146497973;' // Point A
        '77.0270989293021,11.004680942091724;' // Point B
        '77.02106933847415,11.026375406184485;' // Point C
        '77.03728727396867,11.061035762879257' // Point D
        '?alternatives=false&geometries=polyline&language=en&overview=full&steps=true'
        '&access_token=pk.eyJ1IjoidmFpc2hha3ZsIiwiYSI6ImNsenBxaGY5YzBtcjYycXMzYnRqOHUwd28ifQ.ytNFaZ4ZbCHy1KBV3fmR3A';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Extract polyline data
        final String polyline = decoded['routes'][0]['geometry'];
        final List<List<double>> coordinates = decodePolyline(polyline);

        // Extract duration (in seconds)
        final double durationInSeconds = decoded['routes'][0]['duration'];

        // Return both coordinates and duration
        return {
          'coordinates': coordinates,
          'duration': durationInSeconds,
        };
      } else {
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching directions: $e');
      rethrow;
    }
  }

  /// Decode polyline into a list of coordinates
  List<List<double>> decodePolyline(String polyline) {
    final List<int> bytes =
        polyline.codeUnits; // Get ASCII codes for the polyline string
    final List<List<double>> coordinates = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < bytes.length) {
      int shift = 0;
      int result = 0;

      // Decode Latitude
      while (index < bytes.length) {
        int b = bytes[index++] - 63; // Subtract 63 from ASCII value
        result |= (b & 0x1F) << shift; // Add lower 5 bits of byte to result
        shift += 5;
        if (b < 0x20) break; // Break if 'b' is last segment
      }

      if (index > bytes.length) break; // Avoid out-of-bounds error
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;

      // Decode Longitude
      while (index < bytes.length) {
        int b = bytes[index++] - 63; // Subtract 63 from ASCII value
        result |= (b & 0x1F) << shift; // Add lower 5 bits of byte to result
        shift += 5;
        if (b < 0x20) break; // Break if 'b' is last segment
      }

      if (index > bytes.length) break; // Avoid out-of-bounds error
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      // Convert to Latitude and Longitude (Divide by 1E5)
      coordinates.add([lat / 1e5, lng / 1e5]);
    }

    return coordinates;
  }

  /// Add Polyline to the map
  void addPolylineToMap(List<List<double>> coordinates) async {
    polylineAnnotationManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();

    // Convert the list of coordinates to a list of Position directly
    final List<Position> positions = coordinates
        .map((coord) => Position(coord[1], coord[0]))
        .toList(); // coord[1] is longitude, coord[0] is latitude

    // Create PolylineAnnotationOptions
    PolylineAnnotationOptions polylineAnnotationOptions =
        PolylineAnnotationOptions(
      geometry: LineString(coordinates: positions), // Pass List<Position> here
      lineColor: 0xFFFFFF00, // Yellow color
      lineWidth: 4.0,
      lineOpacity: 0.8,
    );

    polylineAnnotationManager?.create(polylineAnnotationOptions);
  }

  /// Called when the Map is created
  // void _onMapCreated(MapboxMap mapboxMap) async {
  //   this.mapboxMap = mapboxMap;

  //   // Initialize annotation managers
  //   pointAnnotationManager =
  //       await mapboxMap.annotations.createPointAnnotationManager();
  //   circleAnnotationManager =
  //       await mapboxMap.annotations.createCircleAnnotationManager();

  //   // Fetch directions and add polyline to map
  //   final List<List<double>> routeCoordinates = await fetchDirections();
  //   addPolylineToMap(routeCoordinates);

  //   // Load and resize the marker image
  //   final Uint8List imageData =
  //       await loadAndResizeImage('assets/icons/circle.png', 30, 30);

  //   // Add Marker Annotation
  //   PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
  //     geometry: Point(
  //       // coordinates: Position(-74.00913, 40.75183),
  //       coordinates: Position(77.06744400748192, 11.005328146497973),
  //     ),
  //     image: imageData,
  //   );
  //   await pointAnnotationManager?.create(pointAnnotationOptions);

  //   // Add Geofence Circle
  //   CircleAnnotationOptions circleAnnotationOptions = CircleAnnotationOptions(
  //     geometry: Point(
  //       // coordinates: Position(-74.00913, 40.75183),
  //       coordinates: Position(77.06744400748192, 11.005328146497973),
  //     ),
  //     circleRadius: 30, // Radius in pixels
  //     circleColor: 0x4D0080FF, // Transparent Blue
  //     circleOpacity: 0.3, // Transparency level
  //     circleStrokeWidth: 1,
  //     circleStrokeColor: 0xFF0096FF, // Solid Blue
  //   );

  //   await circleAnnotationManager?.create(circleAnnotationOptions);

  //   // Smooth camera transition using flyTo
  //   mapboxMap.flyTo(
  //     CameraOptions(
  //       // anchor: ScreenCoordinate(x: 34.43, y: 53.43),
  //       zoom: 17,
  //       bearing: 180,
  //       pitch: 30,
  //     ),
  //     MapAnimationOptions(duration: 2000, startDelay: 0),
  //   );
  // }
  double? drivingTimeInMinutes;

  /// Called when the Map is created
  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    // Initialize annotation managers
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    circleAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();

    // Fetch directions and add polyline to map
    final directions =
        await fetchDirections(); // Fetch both coordinates and duration
    final List<List<double>> routeCoordinates = directions['coordinates'];
    final double durationInSeconds = directions['duration'];

    // Save the driving time in minutes
    setState(() {
      drivingTimeInMinutes = durationInSeconds / 60;
    });

    // Add the polyline to the map
    addPolylineToMap(routeCoordinates);

    // Load and resize the marker image
    final Uint8List imageData =
        await loadAndResizeImage('assets/icons/circle.png', 30, 30);

    // Add Marker Annotation
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(77.06744400748192, 11.005328146497973),
      ),
      image: imageData,
    );
    await pointAnnotationManager?.create(pointAnnotationOptions);

    // Add Geofence Circle
    CircleAnnotationOptions circleAnnotationOptions = CircleAnnotationOptions(
      geometry: Point(
        coordinates: Position(77.06744400748192, 11.005328146497973),
      ),
      circleRadius: 30, // Radius in pixels
      circleColor: 0x4D0080FF, // Transparent Blue
      circleOpacity: 0.3, // Transparency level
      circleStrokeWidth: 1,
      circleStrokeColor: 0xFF0096FF, // Solid Blue
    );

    await circleAnnotationManager?.create(circleAnnotationOptions);

    // Smooth camera transition using flyTo
    mapboxMap.flyTo(
      CameraOptions(
        zoom: 17,
        bearing: 180,
        pitch: 30,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    // Pass your access token to MapboxOptions
    const String accessToken = String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);

    // Define camera options
    CameraOptions camera = CameraOptions(
      center:
          Point(coordinates: Position(77.06744400748192, 11.005328146497973)),
      zoom: 14.0,
      bearing: 0,
      pitch: 0,
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // No shadow
            title: Text(
              'RouteSync',
              style: TextStyle(
                color: Color(0xF65B5B5B),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontFamily: "AirbnbCereal",
              ),
            ),
            leading: IconButton(
              icon: Image.asset(
                'assets/icons/back-button.png',
                width: 38,
                height: 38,
              ),
              onPressed: () {
                Navigator.pop(context); // Action for back button
              },
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Stack(
            children: [
              MapWidget(
                cameraOptions: camera,
                onMapCreated: _onMapCreated,
              ),
              if (drivingTimeInMinutes != null)
                Positioned(
                  top: 120,
                  right: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Driving Time: ${drivingTimeInMinutes?.toStringAsFixed(2)} minutes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              MyDraggablePage(),
            ],
          ),
        ));
  }
}
