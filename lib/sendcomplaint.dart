// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class SendComplaint extends StatefulWidget {
//   const SendComplaint({super.key});
//
//   @override
//   State<SendComplaint> createState() => _SendComplaintState();
// }
//
// class _SendComplaintState extends State<SendComplaint> {
//
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController complaintController = TextEditingController();
//
//   String url = "";
//   String lid = "";
//
//   Future<void> sendComplaint() async {
//
//     if (!_formKey.currentState!.validate()) return;
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     var response = await http.post(
//       Uri.parse(url + "/send_complaint"),
//       body: {
//         "lid": lid,
//         "complaint": complaintController.text,
//       },
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       Fluttertoast.showToast(msg: "Complaint Sent Successfully");
//       complaintController.clear();
//     } else {
//       Fluttertoast.showToast(msg: "Failed to Send Complaint");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Send Complaint"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//
//               TextFormField(
//                 controller: complaintController,
//                 maxLines: 5,
//                 decoration: const InputDecoration(
//                   labelText: "Enter your complaint",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter complaint" : null,
//               ),
//
//               const SizedBox(height: 20),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: sendComplaint,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                   ),
//                   child: const Text(
//                     "Submit Complaint",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               )
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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendComplaint extends StatefulWidget {
  const SendComplaint({super.key});

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController complaintController = TextEditingController();

  String url = "";
  String lid = "";
  bool isLoading = false;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color successColor = Color(0xFF66BB6A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      url = sp.getString('url') ?? "";
      lid = sp.getString('lid') ?? "";
    });
  }

  Future<void> sendComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      url = sp.getString('url') ?? "";
      lid = sp.getString('lid') ?? "";

      if (url.isEmpty || lid.isEmpty) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "User data not found. Please login again.",
          backgroundColor: errorColor,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );
        return;
      }

      var response = await http.post(
        Uri.parse(url + "/send_complaint"),
        body: {
          "lid": lid,
          "complaint": complaintController.text,
        },
      ).timeout(const Duration(seconds: 10));

      var jsonData = json.decode(response.body);

      setState(() {
        isLoading = false;
      });

      if (jsonData['status'] == "ok") {
        Fluttertoast.showToast(
          msg: "Complaint Sent Successfully!",
          backgroundColor: successColor,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );

        // Clear the form
        complaintController.clear();

        // Show success dialog
        _showSuccessDialog();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Send Complaint. Please try again.",
          backgroundColor: errorColor,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Network error. Check your connection.",
        backgroundColor: errorColor,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
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
                    color: successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thank You!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your complaint has been submitted successfully. We'll get back to you soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Send Complaint",
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
          // Background pattern (optional)
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: BackgroundPatternPainter(color: primaryColor),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.2),
                          accentColor.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.feedback_outlined,
                      size: 60,
                      color: primaryColor.withOpacity(0.8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Center(
                  child: Text(
                    "We're Here to Help",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    "Your feedback helps us improve our service",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Form Card
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Complaint Type (Optional enhancement)
                          const Text(
                            "Describe your issue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Please provide as much detail as possible",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Complaint Text Field
                          TextFormField(
                            controller: complaintController,
                            maxLines: 8,
                            minLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter your complaint here...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: errorColor,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: errorColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.edit_note,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your complaint";
                              }
                              if (value.length < 10) {
                                return "Complaint must be at least 10 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Character count (Optional)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${complaintController.text.length} / 500",
                              style: TextStyle(
                                fontSize: 12,
                                color: complaintController.text.length > 500
                                    ? errorColor
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : sendComplaint,
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
                                children: const [
                                  Icon(Icons.send, size: 18),
                                  SizedBox(width: 10),
                                  Text(
                                    "Submit Complaint",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Help Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
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
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.support_agent,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Need immediate assistance?",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Contact our support team at support@example.com",
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

                const SizedBox(height: 16),

                // Privacy Note
                Center(
                  child: Text(
                    "Your complaint will be handled confidentially",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
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
    complaintController.dispose();
    super.dispose();
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double i = -size.width; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}