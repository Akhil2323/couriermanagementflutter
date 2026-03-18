// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class DeliveryAgentProfilePage extends StatefulWidget {
//   const DeliveryAgentProfilePage({super.key});
//
//   @override
//   State<DeliveryAgentProfilePage> createState() => _DeliveryAgentProfilePageState();
// }
//
// class _DeliveryAgentProfilePageState extends State<DeliveryAgentProfilePage> {
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController vehicleController = TextEditingController();
//
//   String url = "";
//   String lid = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadProfile();
//   }
//
//   Future<void> loadProfile() async {
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     if (url.isEmpty || lid.isEmpty) {
//       Fluttertoast.showToast(msg: "URL or Login ID missing");
//       return;
//     }
//
//     try {
//
//       var response = await http.post(
//         Uri.parse("$url/deliveryagent_view_profile/"),
//         body: {"lid": lid},
//       );
//
//       print(response.body);
//
//       var data = json.decode(response.body);
//
//       if (data['status'] == "ok") {
//
//         setState(() {
//           nameController.text = data['name'].toString();
//           emailController.text = data['email'].toString();
//           vehicleController.text = data['vehicle_number'].toString();
//         });
//
//       } else {
//
//         Fluttertoast.showToast(
//             msg: data['message'] ?? "Failed to load profile");
//
//       }
//
//     } catch (e) {
//
//       Fluttertoast.showToast(msg: "Error : $e");
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       appBar: AppBar(
//         title: const Text("Delivery Agent Profile"),
//         backgroundColor: Colors.teal,
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//
//         child: SingleChildScrollView(
//
//           child: Column(
//
//             children: [
//
//               const SizedBox(height: 20),
//
//               TextField(
//                 controller: nameController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Name",
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: emailController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               TextField(
//                 controller: vehicleController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Vehicle Number",
//                   prefixIcon: Icon(Icons.local_shipping),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeliveryAgentProfilePage extends StatefulWidget {
  const DeliveryAgentProfilePage({super.key});

  @override
  State<DeliveryAgentProfilePage> createState() => _DeliveryAgentProfilePageState();
}

class _DeliveryAgentProfilePageState extends State<DeliveryAgentProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String url = "";
  String lid = "";
  bool isLoading = true;
  String? errorMessage;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      url = sp.getString('url') ?? "";
      lid = sp.getString('lid') ?? "";

      if (url.isEmpty || lid.isEmpty) {
        setState(() {
          errorMessage = "URL or Login ID missing";
          isLoading = false;
        });
        return;
      }

      var response = await http.post(
        Uri.parse("$url/deliveryagent_view_profile/"),
        body: {"lid": lid},
      ).timeout(const Duration(seconds: 10));

      print(response.body);

      var data = json.decode(response.body);

      if (data['status'] == "ok") {
        setState(() {
          nameController.text = data['name']?.toString() ?? '';
          emailController.text = data['email']?.toString() ?? '';
          vehicleController.text = data['vehicle_number']?.toString() ?? '';
          phoneController.text = data['phone']?.toString() ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data['message'] ?? "Failed to load profile";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error loading profile";
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: $e");
    }
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
          "Agent Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadProfile,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      )
          : errorMessage != null
          ? _buildErrorWidget()
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header with Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
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
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Profile Avatar with Vehicle Icon
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Text(
                            nameController.text.isNotEmpty
                                ? nameController.text[0].toUpperCase()
                                : "A",
                            style: TextStyle(
                              fontSize: 48,
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Agent Name
                  Text(
                    nameController.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Agent Role
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Information Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Personal Information Section
                  _buildSectionHeader(
                    title: "Personal Information",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 12),

                  // Name Card
                  _buildInfoCard(
                    icon: Icons.person,
                    label: "Full Name",
                    value: nameController.text,
                    color: primaryColor,
                  ),

                  const SizedBox(height: 12),

                  // Email Card
                  _buildInfoCard(
                    icon: Icons.email,
                    label: "Email Address",
                    value: emailController.text,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 12),

                  // Phone Card
                  if (phoneController.text.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.phone,
                      label: "Phone Number",
                      value: phoneController.text,
                      color: Colors.green,
                    ),

                  const SizedBox(height: 24),

                  // Vehicle Information Section
                  _buildSectionHeader(
                    title: "Vehicle Information",
                    icon: Icons.local_shipping,
                  ),

                  const SizedBox(height: 12),

                  // Vehicle Number Card
                  _buildInfoCard(
                    icon: Icons.confirmation_number,
                    label: "Vehicle Number",
                    value: vehicleController.text,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 24),

                  // Status Card
                  _buildStatusCard(),

                  const SizedBox(height: 30),

                  // View-Only Footer Note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "This is a view-only profile",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
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

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? "Something went wrong",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Label and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Verified icon for email
          if (label == "Email Address")
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.green,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            accentColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Status",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Verified Delivery Agent",
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    vehicleController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}