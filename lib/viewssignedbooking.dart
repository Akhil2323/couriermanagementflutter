// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'updatestatus.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class AssignedBookingsPage extends StatefulWidget {
//   const AssignedBookingsPage({super.key});
//
//   @override
//   State<AssignedBookingsPage> createState() => _AssignedBookingsPageState();
// }
//
// class _AssignedBookingsPageState extends State<AssignedBookingsPage> {
//   String url = "";
//   String lid = "";
//   List bookings = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadBookings();
//   }
//
//   Future<void> loadBookings() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     if (url.isEmpty || lid.isEmpty) return;
//
//     try {
//       var response = await http.post(
//         Uri.parse("$url/deliveryagent_assigned_bookings/"),
//         body: {"lid": lid},
//       );
//       var data = json.decode(response.body);
//       if (data['status'] == "ok") {
//         setState(() {
//           bookings = data['bookings'];
//         });
//       } else {
//         Fluttertoast.showToast(msg: data['message'] ?? "Failed to load bookings");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Assigned Bookings"),
//         backgroundColor: Colors.teal,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: bookings.length,
//         itemBuilder: (context, index) {
//           var b = bookings[index];
//           return Card(
//             margin: const EdgeInsets.only(bottom: 12),
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Service: ${b['service_name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
//                   Text("Sender: ${b['sender_address']}"),
//                   Text("Receiver: ${b['receiver_name']} (${b['receiver_phone']})"),
//                   Text("Receiver Address: ${b['receiver_address']}"),
//                   Text("Package Weight: ${b['package_weight']}"),
//                   Text("Booking Date: ${b['booking_date']}"),
//                   Text("Status: ${b['status']}"),
//                   Text("Delivery Status: ${b['deliverystatus']}"),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UpdateDeliveryStatusPage(
//                             bookingId: b['id'].toString(),
//                             currentStatus: b['deliverystatus'],
//                           ),
//                         ),
//                       ).then((_) => loadBookings()); // refresh after update
//                     },
//                     child: const Text("Update Delivery Status"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'updatestatus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssignedBookingsPage extends StatefulWidget {
  const AssignedBookingsPage({super.key});

  @override
  State<AssignedBookingsPage> createState() => _AssignedBookingsPageState();
}

class _AssignedBookingsPageState extends State<AssignedBookingsPage> {
  String url = "";
  String lid = "";
  List bookings = [];
  bool isLoading = true;
  String? errorMessage;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
  static const Color pendingColor = Color(0xFFFFA726); // Orange
  static const Color inProgressColor = Color(0xFF42A5F5); // Blue
  static const Color deliveredColor = Color(0xFF66BB6A); // Green

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
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
          errorMessage = "User data not found";
          isLoading = false;
        });
        return;
      }

      var response = await http.post(
        Uri.parse("$url/deliveryagent_assigned_bookings/"),
        body: {"lid": lid},
      ).timeout(const Duration(seconds: 10));

      var data = json.decode(response.body);

      if (data['status'] == "ok") {
        setState(() {
          bookings = data['bookings'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data['message'] ?? "Failed to load bookings";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error. Check connection.";
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return pendingColor;
      case 'in progress':
      case 'inprogress':
        return inProgressColor;
      case 'delivered':
        return deliveredColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'in progress':
      case 'inprogress':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      // Assuming date format is YYYY-MM-DD
      var parts = dateStr.split(' ');
      if (parts.isNotEmpty) {
        var dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          "Assigned Bookings",
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
            onPressed: loadBookings,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadBookings,
        color: primaryColor,
        child: isLoading
            ? _buildShimmerLoader()
            : errorMessage != null
            ? _buildErrorWidget()
            : bookings.isEmpty
            ? _buildEmptyState()
            : _buildBookingsList(),
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
              onPressed: loadBookings,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_turned_in_outlined,
                size: 80,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Assigned Bookings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You don't have any bookings assigned yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        var b = bookings[index];
        return _buildBookingCard(b);
      },
    );
  }

  Widget _buildBookingCard(var booking) {
    Color statusColor = _getStatusColor(booking['deliverystatus'] ?? 'pending');
    IconData statusIcon = _getStatusIcon(booking['deliverystatus'] ?? 'pending');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(20),
        shadowColor: primaryColor.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with service name and status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.03),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delivery_dining,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['service_name'] ?? 'Service',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(booking['booking_date']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking['deliverystatus'] ?? 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Booking Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Sender Information
                    _buildDetailSection(
                      title: "Sender",
                      icon: Icons.location_on,
                      color: Colors.blue,
                      content: booking['sender_address'] ?? 'N/A',
                    ),

                    const SizedBox(height: 16),

                    // Receiver Information
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.person,
                            label: "Receiver",
                            value: booking['receiver_name'] ?? 'N/A',
                          ),
                          const Divider(height: 16),
                          _buildDetailRow(
                            icon: Icons.phone,
                            label: "Phone",
                            value: booking['receiver_phone'] ?? 'N/A',
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            icon: Icons.location_city,
                            label: "Address",
                            value: booking['receiver_address'] ?? 'N/A',
                            isAddress: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Package Details
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.fitness_center,
                            label: "Weight",
                            value: "${booking['package_weight']} kg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.info,
                            label: "Booking ID",
                            value: "#${booking['id']}",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Update Status Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeliveryStatusPage(
                                bookingId: booking['id'].toString(),
                                currentStatus: booking['deliverystatus'],
                              ),
                            ),
                          ).then((_) => loadBookings()); // refresh after update
                        },
                        icon: const Icon(Icons.update, size: 18),
                        label: const Text(
                          "Update Delivery Status",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAddress = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: isAddress ? 3 : 1,
            overflow: isAddress ? TextOverflow.ellipsis : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}