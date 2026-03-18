// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewReviews extends StatefulWidget {
//   const ViewReviews({super.key});
//
//   @override
//   State<ViewReviews> createState() => _ViewReviewsState();
// }
//
// class _ViewReviewsState extends State<ViewReviews> {
//
//   List reviews = [];
//   String url = "";
//   String lid = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadReviews();
//   }
//
//   Future<void> loadReviews() async {
//
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     var response = await http.post(
//       Uri.parse(url + "/view_my_reviews"),
//       body: {"lid": lid},
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         reviews = jsonData['data'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Reviews"),
//         backgroundColor: Colors.teal,
//       ),
//       body: reviews.isEmpty
//           ? const Center(child: Text("No Reviews Found"))
//           : ListView.builder(
//         itemCount: reviews.length,
//         itemBuilder: (context, index) {
//
//           var r = reviews[index];
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   /// Delivery Agent Name
//                   Text(
//                     r['agent_name'],
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 6),
//
//                   /// Rating
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber),
//                       const SizedBox(width: 4),
//                       Text("${r['rating']} / 5"),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   /// Review
//                   Text(r['review']),
//
//                   const SizedBox(height: 10),
//
//                   /// Date
//                   Text(
//                     "Date: ${r['date']}",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
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

class ViewReviews extends StatefulWidget {
  const ViewReviews({super.key});

  @override
  State<ViewReviews> createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  List reviews = [];
  String url = "";
  String lid = "";
  bool isLoading = true;
  String? errorMessage;

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color starColor = Color(0xFFFFB74D); // Amber for stars

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future<void> loadReviews() async {
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
        Uri.parse(url + "/view_my_reviews"),
        body: {"lid": lid},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == "ok") {
          setState(() {
            reviews = jsonData['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Failed to load reviews";
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
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildStarRating(String rating) {
    int ratingValue = int.tryParse(rating) ?? 0;
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < ratingValue ? Icons.star : Icons.star_border,
          color: starColor,
          size: 18,
        );
      }),
    );
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
                const SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
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
          "My Reviews",
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
            onPressed: loadReviews,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadReviews,
        color: primaryColor,
        child: isLoading
            ? _buildShimmerLoader()
            : errorMessage != null
            ? _buildErrorWidget()
            : reviews.isEmpty
            ? _buildEmptyState()
            : _buildReviewsList(),
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
              onPressed: loadReviews,
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
                Icons.rate_review_outlined,
                size: 80,
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Reviews Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You haven't written any reviews yet",
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
              icon: const Icon(Icons.star),
              label: const Text("Write a Review"),
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

  Widget _buildReviewsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        var r = reviews[index];
        return _buildReviewCard(r);
      },
    );
  }

  Widget _buildReviewCard(var review) {
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
              // Header with agent info
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
                    // Agent Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            secondaryColor,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          review['agent_name']?[0].toUpperCase() ?? 'A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Agent Name and Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['agent_name'] ?? 'Delivery Agent',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildStarRating(review['rating'] ?? '0'),
                        ],
                      ),
                    ),

                    // Date
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatDate(review['date']),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Review Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Review Title based on rating
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 16,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getRatingTitle(review['rating']),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Review Text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        review['review'] ?? 'No review text',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rating Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: starColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: starColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${review['rating']}/5',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: starColor,
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
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingTitle(String rating) {
    int value = int.tryParse(rating) ?? 0;
    switch (value) {
      case 1:
        return "Poor Experience";
      case 2:
        return "Below Average";
      case 3:
        return "Good Service";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent!";
      default:
        return "Review";
    }
  }
}