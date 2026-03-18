// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
//
// import 'login.dart';
// import 'viewdeliveryagentprofile.dart';
// import 'viewssignedbooking.dart';
// import 'changepassword.dart';
//
// class DeliveryHome extends StatefulWidget {
//   const DeliveryHome({super.key});
//
//   @override
//   State<DeliveryHome> createState() => _DeliveryHomeState();
// }
//
// class _DeliveryHomeState extends State<DeliveryHome> {
//
//   Timer? locationTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     startLocationTracking();
//   }
//
//   /// START LOCATION TRACKING
//   void startLocationTracking() {
//     locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       sendLocation();
//     });
//   }
//
//   /// SEND LOCATION TO DJANGO
//   Future<void> sendLocation() async {
//     try {
//
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;
//
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       SharedPreferences sp = await SharedPreferences.getInstance();
//
//       String url = sp.getString('url') ?? '';
//       String lid = sp.getString('lid') ?? '';
//
//       await http.post(
//         Uri.parse('$url/updatelocation/'),
//         body: {
//           'lid': lid,
//           'lat': position.latitude.toString(),
//           'lon': position.longitude.toString(),
//         },
//       );
//
//       print("Location Sent: ${position.latitude}, ${position.longitude}");
//
//     } catch (e) {
//       print("Location Error: $e");
//     }
//   }
//
//   /// LOGOUT FUNCTION
//   Future<void> logout() async {
//
//     locationTimer?.cancel();
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//
//     String? serverUrl = sp.getString('url');
//
//     await sp.clear();
//
//     if (serverUrl != null) {
//       await sp.setString('url', serverUrl);
//     }
//
//     if (!mounted) return;
//
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const MyLoginPage(title: "Login"),
//       ),
//           (route) => false,
//     );
//   }
//
//   /// LOGOUT CONFIRMATION
//   void confirmLogout() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Logout"),
//           content: const Text("Are you sure you want to logout?"),
//           actions: [
//
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 logout();
//               },
//               child: const Text("Logout"),
//             ),
//
//           ],
//         );
//       },
//     );
//   }
//
//   /// MENU CARD
//   Widget menuCard(String title, IconData icon, VoidCallback onTap) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(icon, size: 30, color: Colors.teal),
//           title: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     locationTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       appBar: AppBar(
//         title: const Text("Delivery Agent Home"),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//
//             const SizedBox(height: 10),
//
//             menuCard(
//               "View Profile",
//               Icons.person,
//                   () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const DeliveryAgentProfilePage(),
//                   ),
//                 );
//               },
//             ),
//
//             menuCard(
//               "View Assigned Booking",
//               Icons.local_shipping,
//                   () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AssignedBookingsPage(),
//                   ),
//                 );
//               },
//             ),
//
//
//
//             menuCard(
//               "Change Password",
//               Icons.lock,
//                   () {},
//             ),
//
//             const SizedBox(height: 15),
//
//             menuCard(
//               "Logout",
//               Icons.logout,
//                   () {
//                 confirmLogout();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
import 'viewdeliveryagentprofile.dart';
import 'viewssignedbooking.dart';
import 'changepassword.dart';

class DeliveryHome extends StatefulWidget {
  const DeliveryHome({super.key});

  @override
  State<DeliveryHome> createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
  Timer? locationTimer;
  String agentName = "Agent";
  bool isLocationActive = true;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
  static const Color onlineColor = Color(0xFF4CAF50); // Green
  static const Color offlineColor = Color(0xFF9E9E9E); // Grey

  @override
  void initState() {
    super.initState();
    startLocationTracking();
    loadAgentName();
  }

  Future<void> loadAgentName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      agentName = sp.getString('agent_name') ?? 'Agent';
    });
  }

  /// START LOCATION TRACKING
  void startLocationTracking() {
    locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      sendLocation();
    });
  }

  /// SEND LOCATION TO DJANGO
  Future<void> sendLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isLocationActive = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          isLocationActive = false;
        });
        return;
      }

      setState(() {
        isLocationActive = true;
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      SharedPreferences sp = await SharedPreferences.getInstance();

      String url = sp.getString('url') ?? '';
      String lid = sp.getString('lid') ?? '';

      await http.post(
        Uri.parse('$url/updatelocation/'),
        body: {
          'lid': lid,
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
        },
      );

      print("Location Sent: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Location Error: $e");
    }
  }

  /// LOGOUT FUNCTION
  Future<void> logout() async {
    locationTimer?.cancel();

    SharedPreferences sp = await SharedPreferences.getInstance();

    String? serverUrl = sp.getString('url');

    await sp.clear();

    if (serverUrl != null) {
      await sp.setString('url', serverUrl);
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MyLoginPage(title: "Login"),
      ),
          (route) => false,
    );
  }

  /// LOGOUT CONFIRMATION
  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ENHANCED MENU CARD
  Widget menuCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        shadowColor: primaryColor.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// STAT CARD FOR DASHBOARD
  Widget statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Agent Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, secondaryColor],
            ),
          ),
        ),
        actions: [
          // Online/Offline Indicator
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isLocationActive ? onlineColor : offlineColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isLocationActive ? "Online" : "Offline",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor,
                    primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Profile Avatar
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            agentName.isNotEmpty ? agentName[0].toUpperCase() : "A",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isLocationActive ? onlineColor : offlineColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Welcome, $agentName!",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Delivery Agent",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Quick Stats
                  Row(
                    children: [
                      statCard(
                        icon: Icons.local_shipping,
                        label: "Assigned",
                        value: "3",
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      statCard(
                        icon: Icons.inventory,
                        label: "Picked Up",
                        value: "2",
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      statCard(
                        icon: Icons.check_circle,
                        label: "Delivered",
                        value: "5",
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main Menu Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Main Menu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // View Profile Card
                  menuCard(
                    title: "View Profile",
                    icon: Icons.person,
                    subtitle: "Check your profile information",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeliveryAgentProfilePage(),
                        ),
                      );
                    },
                  ),

                  // View Assigned Bookings Card
                  menuCard(
                    title: "Assigned Bookings",
                    icon: Icons.local_shipping,
                    subtitle: "View and manage your deliveries",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AssignedBookingsPage(),
                        ),
                      );
                    },
                  ),

                  // Change Password Card - FIXED: Now properly navigates to ChangePassword
                  menuCard(
                    title: "Change Password",
                    icon: Icons.lock,
                    subtitle: "Update your account password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // Logout Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(16),
                      shadowColor: Colors.red.withOpacity(0.2),
                      child: InkWell(
                        onTap: confirmLogout,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Sign out from your account",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Location Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isLocationActive
                          ? onlineColor.withOpacity(0.1)
                          : offlineColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isLocationActive
                            ? onlineColor.withOpacity(0.3)
                            : offlineColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isLocationActive ? Icons.location_on : Icons.location_off,
                          color: isLocationActive ? onlineColor : offlineColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLocationActive
                                    ? "Location Tracking Active"
                                    : "Location Tracking Inactive",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isLocationActive
                                      ? onlineColor
                                      : offlineColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isLocationActive
                                    ? "Your location is being shared every 5 seconds"
                                    : "Enable location services for tracking",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}