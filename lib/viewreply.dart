// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewComplaints extends StatefulWidget {
//   const ViewComplaints({super.key});
//
//   @override
//   State<ViewComplaints> createState() => _ViewComplaintsState();
// }
//
// class _ViewComplaintsState extends State<ViewComplaints> {
//
//   List complaints = [];
//   String url = "";
//   String lid = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadComplaints();
//   }
//
//   Future<void> loadComplaints() async {
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     var response = await http.post(
//       Uri.parse(url + "/view_my_complaints"),
//       body: {"lid": lid},
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         complaints = jsonData['data'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Complaints"),
//         backgroundColor: Colors.teal,
//       ),
//       body: complaints.isEmpty
//           ? const Center(child: Text("No Complaints Found"))
//           : ListView.builder(
//         itemCount: complaints.length,
//         itemBuilder: (context, index) {
//
//           var c = complaints[index];
//
//           bool hasReply = c['reply'] != "No Reply Yet";
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Text(
//                     "Complaint",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red.shade700,
//                     ),
//                   ),
//
//                   const SizedBox(height: 6),
//
//                   Text(c['complaint']),
//
//                   const SizedBox(height: 10),
//
//                   Text(
//                     "Date: ${c['date']}",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//
//                   const Divider(height: 25),
//
//                   Text(
//                     "Admin Reply",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: hasReply ? Colors.green : Colors.orange,
//                     ),
//                   ),
//
//                   const SizedBox(height: 6),
//
//                   Text(
//                     c['reply'],
//                     style: TextStyle(
//                       color: hasReply ? Colors.black : Colors.orange,
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ViewComplaints extends StatefulWidget {
  const ViewComplaints({super.key});

  @override
  State<ViewComplaints> createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {
  List complaints = [];
  String url = "";
  String lid = "";
  bool isLoading = true;
  String? errorMessage;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color pendingColor = Color(0xFFFFA726); // Orange
  static const Color resolvedColor = Color(0xFF66BB6A); // Green
  static const Color complaintColor = Color(0xFFEF5350); // Red

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
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
          errorMessage = "User data not found. Please login again.";
          isLoading = false;
        });
        return;
      }

      var response = await http.post(
        Uri.parse(url + "/view_my_complaints"),
        body: {"lid": lid},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == "ok") {
          setState(() {
            complaints = jsonData['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Failed to load complaints";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error. Check your connection.";
        isLoading = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
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
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
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
          "My Complaints",
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadComplaints,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadComplaints,
        color: primaryColor,
        child: isLoading
            ? _buildShimmerLoader()
            : errorMessage != null
            ? _buildErrorWidget()
            : complaints.isEmpty
            ? _buildEmptyState()
            : _buildComplaintsList(),
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
              onPressed: loadComplaints,
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
                Icons.feedback_outlined,
                size: 80,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Complaints Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You haven't submitted any complaints yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add_comment),
              label: const Text("Submit a Complaint"),
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

  Widget _buildComplaintsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        var c = complaints[index];
        return _buildComplaintCard(c);
      },
    );
  }

  Widget _buildComplaintCard(var complaint) {
    bool hasReply = complaint['reply'] != "No Reply Yet";
    Color statusColor = hasReply ? resolvedColor : pendingColor;
    String statusText = hasReply ? "Resolved" : "Pending";
    IconData statusIcon = hasReply ? Icons.check_circle : Icons.hourglass_empty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Header with status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: statusColor.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        statusIcon,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDate(complaint['date']),
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Complaint Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Complaint Section
                    _buildSection(
                      icon: Icons.report_problem,
                      color: complaintColor,
                      title: "Your Complaint",
                      content: complaint['complaint'],
                      timestamp: _formatDate(complaint['date']),
                    ),

                    const SizedBox(height: 16),

                    // Divider with icon
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: statusColor,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Reply Section
                    _buildSection(
                      icon: Icons.support_agent,
                      color: hasReply ? resolvedColor : pendingColor,
                      title: hasReply ? "Admin Response" : "Awaiting Response",
                      content: complaint['reply'],
                      isReply: true,
                      hasReply: hasReply,
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

  Widget _buildSection({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
    String? timestamp,
    bool isReply = false,
    bool hasReply = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              if (timestamp != null && !isReply) ...[
                const Spacer(),
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: isReply && !hasReply
                    ? pendingColor.withOpacity(0.7)
                    : Colors.black87,
                fontStyle: isReply && !hasReply ? FontStyle.italic : null,
                height: 1.5,
              ),
            ),
          ),
          if (isReply && timestamp != null && hasReply) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                timestamp,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}