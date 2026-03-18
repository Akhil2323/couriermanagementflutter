// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
// import 'viewandeditprofile.dart';
// import 'viewservices.dart';
// import 'viewbooking.dart';
// import 'sendcomplaint.dart';
// import 'viewreply.dart';
// import 'sendreview.dart';
// import 'viewreview.dart';
// import 'changepassword.dart';
//
// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   /// LOGOUT FUNCTION
//   Future<void> logout() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//
//     // Only remove session info like user ID, email, token etc.
//     await sp.remove('lid'); // remove login id
//     await sp.remove('user_type'); // remove user type
//     // Keep 'url' if you are using it to connect to your backend server
//
//     if (!mounted) return;
//
//     // Navigate to login page
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
//           content: const Text("Do you want to logout?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 logout();
//               },
//               child: const Text(
//                 "Logout",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
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
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           leading: Icon(
//             icon,
//             size: 30,
//             color: Colors.teal,
//           ),
//           title: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           trailing: const Icon(Icons.arrow_forward_ios),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Home"),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               menuCard(
//                 "View & Edit Profile",
//                 Icons.person,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ViewEditProfile()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "View Service",
//                 Icons.miscellaneous_services,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ServiceList()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "View Booking Status",
//                 Icons.assignment,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ViewMyBookings()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "Send Complaint",
//                 Icons.report_problem,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SendComplaint()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "View Reply",
//                 Icons.message,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ViewComplaints()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "Send Review",
//                 Icons.rate_review,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SendReview()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "View Review",
//                 Icons.reviews,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ViewReviews()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "Change Password",
//                 Icons.lock,
//                     () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ChangePassword()),
//                   );
//                 },
//               ),
//               menuCard(
//                 "Logout",
//                 Icons.logout,
//                     () {
//                   confirmLogout();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'viewandeditprofile.dart';
import 'viewservices.dart';
import 'viewbooking.dart';
import 'sendcomplaint.dart';
import 'viewreply.dart';
import 'sendreview.dart';
import 'viewreview.dart';
import 'changepassword.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String userName = "User";
  String userEmail = "";

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userName = sp.getString('user_name') ?? "User";
      userEmail = sp.getString('user_email') ?? "";
    });
  }

  /// LOGOUT FUNCTION
  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Only remove session info like user ID, email, token etc.
    await sp.remove('lid'); // remove login id
    await sp.remove('user_type'); // remove user type
    await sp.remove('user_name');
    await sp.remove('user_email');
    // Keep 'url' if you are using it to connect to your backend server

    if (!mounted) return;

    // Navigate to login page
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
    Color? iconColor,
    String? subtitle,
    int? count,
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
              gradient: LinearGradient(
                colors: [
                  cardBackgroundColor,
                  cardBackgroundColor.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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

                // Count badge if provided
                if (count != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

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

  /// QUICK ACTION BUTTON
  Widget quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: primaryColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          "Dashboard",
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to notifications
            },
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
                        userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Welcome back, $userName!",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("Bookings", "8", Icons.assignment),
                      _buildStatItem("Reviews", "4", Icons.star),
                      _buildStatItem("Complaints", "2", Icons.report),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      quickActionButton(
                        icon: Icons.search,
                        label: "Browse",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServiceList(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      quickActionButton(
                        icon: Icons.track_changes,
                        label: "Track",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewMyBookings(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      quickActionButton(
                        icon: Icons.edit_note,
                        label: "Review",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SendReview(),
                            ),
                          );
                        },
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

                  menuCard(
                    title: "View & Edit Profile",
                    icon: Icons.person,
                    subtitle: "Manage your personal information",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewEditProfile(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "View Services",
                    icon: Icons.miscellaneous_services,
                    subtitle: "Browse available delivery services",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServiceList(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "Booking Status",
                    icon: Icons.assignment,
                    subtitle: "Track your current bookings",
                    count: 3,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewMyBookings(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "Send Complaint",
                    icon: Icons.report_problem,
                    subtitle: "Report any issues",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SendComplaint(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "View Complaints",
                    icon: Icons.message,
                    subtitle: "Check complaint status",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewComplaints(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "Send Review",
                    icon: Icons.rate_review,
                    subtitle: "Rate delivery agents",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SendReview(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "View Reviews",
                    icon: Icons.reviews,
                    subtitle: "See your past reviews",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewReviews(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "Change Password",
                    icon: Icons.lock,
                    subtitle: "Update your password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      );
                    },
                  ),

                  menuCard(
                    title: "Logout",
                    icon: Icons.logout,
                    subtitle: "Sign out from your account",
                    onTap: confirmLogout,
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}