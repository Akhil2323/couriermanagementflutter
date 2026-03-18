// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class SendReview extends StatefulWidget {
//   const SendReview({super.key});
//
//   @override
//   State<SendReview> createState() => _SendReviewState();
// }
//
// class _SendReviewState extends State<SendReview> {
//
//   List agents = [];
//   String? selectedAgentId;
//   String selectedRating = "5";
//
//   TextEditingController reviewController = TextEditingController();
//
//   String url = "";
//   String lid = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadAgents();
//   }
//
//   Future<void> loadAgents() async {
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//
//     var response = await http.get(Uri.parse(url + "/view_delivery_agents"));
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         agents = jsonData['data'];
//       });
//     }
//   }
//
//   Future<void> sendReview() async {
//
//     if (selectedAgentId == null) {
//       Fluttertoast.showToast(msg: "Select Delivery Agent");
//       return;
//     }
//
//     if (reviewController.text.isEmpty) {
//       Fluttertoast.showToast(msg: "Enter review");
//       return;
//     }
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     lid = sp.getString('lid') ?? "";
//
//     var response = await http.post(
//       Uri.parse(url + "/send_review"),
//       body: {
//         "lid": lid,
//         "agent_id": selectedAgentId,
//         "rating": selectedRating,
//         "review": reviewController.text,
//       },
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       Fluttertoast.showToast(msg: "Review Submitted");
//       reviewController.clear();
//       setState(() {
//         selectedAgentId = null;
//         selectedRating = "5";
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Failed to Submit");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Send Review"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             /// Delivery Agent Dropdown
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: "Select Delivery Agent",
//                 border: OutlineInputBorder(),
//               ),
//               value: selectedAgentId,
//               items: agents.map<DropdownMenuItem<String>>((agent) {
//                 return DropdownMenuItem<String>(
//                   value: agent['id'].toString(),
//                   child: Text(agent['name']),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedAgentId = value;
//                 });
//               },
//             ),
//
//             const SizedBox(height: 15),
//
//             /// Rating Dropdown
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: "Rating",
//                 border: OutlineInputBorder(),
//               ),
//               value: selectedRating,
//               items: ["1","2","3","4","5"]
//                   .map((r) => DropdownMenuItem(
//                 value: r,
//                 child: Text("$r ⭐"),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRating = value!;
//                 });
//               },
//             ),
//
//             const SizedBox(height: 15),
//
//             /// Review Text
//             TextField(
//               controller: reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: "Write Review",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: sendReview,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                 ),
//                 child: const Text(
//                   "Submit Review",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             )
//
//           ],
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

class SendReview extends StatefulWidget {
  const SendReview({super.key});

  @override
  State<SendReview> createState() => _SendReviewState();
}

class _SendReviewState extends State<SendReview> {
  List agents = [];
  String? selectedAgentId;
  String selectedRating = "5";
  bool isLoading = false;
  bool isLoadingAgents = true;

  TextEditingController reviewController = TextEditingController();

  String url = "";
  String lid = "";

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color ratingColor = Color(0xFFFFB74D); // Orange for stars

  @override
  void initState() {
    super.initState();
    loadAgents();
  }

  Future<void> loadAgents() async {
    setState(() {
      isLoadingAgents = true;
    });

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      url = sp.getString('url') ?? "";
      lid = sp.getString('lid') ?? "";

      var response = await http.get(
        Uri.parse(url + "/view_delivery_agents"),
      ).timeout(const Duration(seconds: 10));

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "ok") {
        setState(() {
          agents = jsonData['data'] ?? [];
          isLoadingAgents = false;
        });
      } else {
        setState(() {
          isLoadingAgents = false;
        });
        Fluttertoast.showToast(msg: "Failed to load agents");
      }
    } catch (e) {
      setState(() {
        isLoadingAgents = false;
      });
      Fluttertoast.showToast(msg: "Network error. Check connection.");
    }
  }

  Future<void> sendReview() async {
    if (selectedAgentId == null) {
      Fluttertoast.showToast(
        msg: "Please select a delivery agent",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (reviewController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your review",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (reviewController.text.length < 10) {
      Fluttertoast.showToast(
        msg: "Review must be at least 10 characters",
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
      SharedPreferences sp = await SharedPreferences.getInstance();
      lid = sp.getString('lid') ?? "";

      var response = await http.post(
        Uri.parse(url + "/send_review"),
        body: {
          "lid": lid,
          "agent_id": selectedAgentId,
          "rating": selectedRating,
          "review": reviewController.text,
        },
      ).timeout(const Duration(seconds: 10));

      var jsonData = json.decode(response.body);

      setState(() {
        isLoading = false;
      });

      if (jsonData['status'] == "ok") {
        Fluttertoast.showToast(
          msg: "Review Submitted Successfully! 🎉",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );

        // Clear form
        reviewController.clear();
        setState(() {
          selectedAgentId = null;
          selectedRating = "5";
        });

        // Show success dialog
        _showSuccessDialog();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Submit Review",
          backgroundColor: Colors.red,
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
        backgroundColor: Colors.red,
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
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rate_review,
                    color: Colors.green,
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
                Text(
                  "Your review has been submitted successfully. We appreciate your feedback!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
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

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        int starNumber = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRating = starNumber.toString();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              starNumber <= int.parse(selectedRating)
                  ? Icons.star
                  : Icons.star_border,
              color: ratingColor,
              size: 32,
            ),
          ),
        );
      }),
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
          "Write a Review",
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
      body: isLoadingAgents
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      )
          : Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: ReviewBackgroundPainter(color: primaryColor),
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
                // Header Section
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
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
                      Icons.star_rate,
                      size: 50,
                      color: ratingColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    "Share Your Experience",
                    style: TextStyle(
                      fontSize: 22,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Agent Selection
                        const Text(
                          "Select Delivery Agent",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            value: selectedAgentId,
                            hint: const Text("Choose an agent"),
                            items: agents.map<DropdownMenuItem<String>>((agent) {
                              return DropdownMenuItem<String>(
                                value: agent['id'].toString(),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(agent['name'] ?? 'Unknown'),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAgentId = value;
                              });
                            },
                            validator: (value) =>
                            value == null ? "Select an agent" : null,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Rating Section
                        const Text(
                          "Rate Your Experience",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: Column(
                            children: [
                              _buildStarRating(),
                              const SizedBox(height: 8),
                              Text(
                                _getRatingText(selectedRating),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ratingColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Review Text
                        const Text(
                          "Write Your Review",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: TextFormField(
                            controller: reviewController,
                            maxLines: 5,
                            minLines: 3,
                            decoration: InputDecoration(
                              hintText: "Share your experience with the delivery agent...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.edit_note,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Character count
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${reviewController.text.length} / 500",
                            style: TextStyle(
                              fontSize: 12,
                              color: reviewController.text.length > 500
                                  ? Colors.red
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
                            onPressed: isLoading ? null : sendReview,
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
                                  "Submit Review",
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

                const SizedBox(height: 20),

                // Feedback Note
                Center(
                  child: Text(
                    "Your review helps other customers make better choices",
                    textAlign: TextAlign.center,
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

  String _getRatingText(String rating) {
    switch (rating) {
      case "1":
        return "Poor";
      case "2":
        return "Fair";
      case "3":
        return "Good";
      case "4":
        return "Very Good";
      case "5":
        return "Excellent";
      default:
        return "Select Rating";
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}

// Custom painter for background pattern
class ReviewBackgroundPainter extends CustomPainter {
  final Color color;

  ReviewBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double spacing = 30;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}