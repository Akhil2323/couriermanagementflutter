// import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// //
// // class UpdateDeliveryStatusPage extends StatefulWidget {
// //   final String bookingId;
// //   final String currentStatus;
// //
// //   const UpdateDeliveryStatusPage({
// //     super.key,
// //     required this.bookingId,
// //     required this.currentStatus,
// //   });
// //
// //   @override
// //   State<UpdateDeliveryStatusPage> createState() =>
// //       _UpdateDeliveryStatusPageState();
// // }
// //
// // class _UpdateDeliveryStatusPageState extends State<UpdateDeliveryStatusPage> {
// //   String url = "";
// //   String? selectedStatus;
// //   bool isLoading = false;
// //
// //   final List<String> statusList = [
// //     "Pending",
// //     "Picked Up",
// //     "In Transit",
// //     "Delivered",
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     selectedStatus =
// //     statusList.contains(widget.currentStatus) ? widget.currentStatus : null;
// //     loadUrl();
// //   }
// //
// //   Future<void> loadUrl() async {
// //     SharedPreferences sp = await SharedPreferences.getInstance();
// //     setState(() {
// //       url = sp.getString('url') ?? "";
// //     });
// //   }
// //
// //   Future<void> updateStatus() async {
// //     if (selectedStatus == null) {
// //       Fluttertoast.showToast(msg: "Please select a delivery status");
// //       return;
// //     }
// //
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       var response = await http.post(
// //         Uri.parse("$url/deliveryagent_update_status/"),
// //         body: {
// //           "booking_id": widget.bookingId,
// //           "deliverystatus": selectedStatus!,
// //         },
// //       );
// //
// //       var data = json.decode(response.body);
// //
// //       if (data['status'] == "ok") {
// //         Fluttertoast.showToast(
// //           msg: "Status updated successfully",
// //           backgroundColor: Colors.green,
// //         );
// //         Navigator.pop(context, selectedStatus); // pass updated status back
// //       } else {
// //         Fluttertoast.showToast(
// //           msg: data['message'] ?? "Update failed",
// //           backgroundColor: Colors.red,
// //         );
// //       }
// //     } catch (e) {
// //       Fluttertoast.showToast(
// //         msg: "Network error: $e",
// //         backgroundColor: Colors.red,
// //       );
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Update Delivery Status"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             DropdownButtonFormField<String>(
// //               value: selectedStatus,
// //               items: statusList.map((status) {
// //                 return DropdownMenuItem(
// //                   value: status,
// //                   child: Text(status),
// //                 );
// //               }).toList(),
// //               onChanged: (val) {
// //                 setState(() {
// //                   selectedStatus = val;
// //                 });
// //               },
// //               decoration: const InputDecoration(
// //                 labelText: "Delivery Status",
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             SizedBox(
// //               width: double.infinity,
// //               height: 50,
// //               child: ElevatedButton(
// //                 onPressed: isLoading ? null : updateStatus,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.teal,
// //                 ),
// //                 child: isLoading
// //                     ? const CircularProgressIndicator(
// //                   color: Colors.white,
// //                 )
// //                     : const Text(
// //                   "Save Status",
// //                   style: TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateDeliveryStatusPage extends StatefulWidget {
  final String bookingId;
  final String currentStatus;

  const UpdateDeliveryStatusPage({
    super.key,
    required this.bookingId,
    required this.currentStatus,
  });

  @override
  State<UpdateDeliveryStatusPage> createState() =>
      _UpdateDeliveryStatusPageState();
}

class _UpdateDeliveryStatusPageState extends State<UpdateDeliveryStatusPage> {
  String url = "";
  String? selectedStatus;
  bool isLoading = false;

  final List<Map<String, dynamic>> statusList = [
    {"status": "Pending", "icon": Icons.hourglass_empty, "color": Color(0xFFFFA726)},
    {"status": "Picked Up", "icon": Icons.inventory, "color": Color(0xFF42A5F5)},
    {"status": "In Transit", "icon": Icons.local_shipping, "color": Color(0xFF7E57C2)},
    {"status": "Delivered", "icon": Icons.check_circle, "color": Color(0xFF66BB6A)},
  ];

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    // Find the matching status from the list
    var matchingStatus = statusList.firstWhere(
          (s) => s['status'] == widget.currentStatus,
      orElse: () => statusList.first,
    );
    selectedStatus = matchingStatus['status'];
    loadUrl();
  }

  Future<void> loadUrl() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      url = sp.getString('url') ?? "";
    });
  }

  Future<void> updateStatus() async {
    if (selectedStatus == null) {
      Fluttertoast.showToast(
        msg: "Please select a delivery status",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (selectedStatus == widget.currentStatus) {
      Fluttertoast.showToast(
        msg: "Status is already set to $selectedStatus",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("$url/deliveryagent_update_status/"),
        body: {
          "booking_id": widget.bookingId,
          "deliverystatus": selectedStatus!,
        },
      ).timeout(const Duration(seconds: 10));

      var data = json.decode(response.body);

      if (data['status'] == "ok") {
        Fluttertoast.showToast(
          msg: "Status updated successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );

        // Show success dialog before popping
        _showSuccessDialog();
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Update failed",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error. Check connection.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
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
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Status Updated!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Delivery status has been updated to:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(selectedStatus!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(selectedStatus!),
                        color: _getStatusColor(selectedStatus!),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedStatus!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(selectedStatus!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context, selectedStatus); // Go back with status
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    var found = statusList.firstWhere(
          (s) => s['status'] == status,
      orElse: () => statusList.first,
    );
    return found['color'];
  }

  IconData _getStatusIcon(String status) {
    var found = statusList.firstWhere(
          (s) => s['status'] == status,
      orElse: () => statusList.first,
    );
    return found['icon'];
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
          "Update Status",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: UpdateStatusBackgroundPainter(color: primaryColor),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.2),
                          primaryColor.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.update,
                      size: 60,
                      color: primaryColor.withOpacity(0.8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                const Text(
                  "Update Delivery Status",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Booking ID
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Booking ID: #${widget.bookingId}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Current Status Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Status",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(widget.currentStatus).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(widget.currentStatus),
                              color: _getStatusColor(widget.currentStatus),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.currentStatus,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(widget.currentStatus),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Status Selection Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select New Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Custom status selection cards
                      ...statusList.map((status) {
                        bool isSelected = selectedStatus == status['status'];
                        bool isCurrent = widget.currentStatus == status['status'];

                        return GestureDetector(
                          onTap: isCurrent
                              ? null
                              : () {
                            setState(() {
                              selectedStatus = status['status'];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? status['color'].withOpacity(0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? status['color']
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: status['color'].withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    status['icon'],
                                    color: status['color'],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        status['status'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? status['color']
                                              : Colors.black87,
                                        ),
                                      ),
                                      if (isCurrent)
                                        Text(
                                          "Current Status",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: status['color'],
                                    size: 24,
                                  ),
                                if (isCurrent && !isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "Current",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : updateStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          selectedStatus == widget.currentStatus
                              ? "No Changes"
                              : "Update Status",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Note
                if (selectedStatus == widget.currentStatus)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Status is already set to '$selectedStatus'. Select a different status to update.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for background pattern
class UpdateStatusBackgroundPainter extends CustomPainter {
  final Color color;

  UpdateStatusBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double spacing = 30;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * 0.5, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}