// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'booking.dart';
//
// class ServiceList extends StatefulWidget {
//   const ServiceList({super.key});
//
//   @override
//   State<ServiceList> createState() => _ServiceListState();
// }
//
// class _ServiceListState extends State<ServiceList> {
//
//   List services = [];
//   String url = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadServices();
//   }
//
//   Future<void> loadServices() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//
//     var response = await http.get(Uri.parse(url + "/view_services"));
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         services = jsonData['data'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Services")),
//       body: ListView.builder(
//         itemCount: services.length,
//         itemBuilder: (context, index) {
//
//           var service = services[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Text(
//                     service['service_name'],
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   Text(service['description']),
//
//                   const SizedBox(height: 8),
//
//                   Text("₹ ${service['price']}"),
//
//                   const SizedBox(height: 12),
//
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BookingPage(
//                               serviceId: service['id'].toString(),
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text("Book Now"),
//                     ),
//                   )
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
import 'booking.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({super.key});

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  List services = [];
  String url = "";
  bool isLoading = true;
  String? errorMessage;

  // Modern Color Palette
  static const Color primaryColor = Color(0xFF2A9D8F); // Fresh Teal
  static const Color secondaryColor = Color(0xFF264653); // Dark Blue-Grey
  static const Color accentColor = Color(0xFFE9C46A); // Warm Yellow
  static const Color priceColor = Color(0xFFE76F51); // Soft Red/Orange
  static const Color backgroundColor = Color(0xFFF8F9FA); // Light Grey
  static const Color surfaceColor = Colors.white;

  // Service category icons mapping
  final Map<String, IconData> categoryIcons = {
    'delivery': Icons.local_shipping,
    'express': Icons.flash_on,
    'standard': Icons.schedule,
    'fragile': Icons.auto_awesome,
    'heavy': Icons.fitness_center,
    'document': Icons.description,
    'default': Icons.inventory_2_outlined,
  };

  // Service category colors mapping
  final Map<String, Color> categoryColors = {
    'delivery': Color(0xFF2A9D8F),
    'express': Color(0xFFE9C46A),
    'standard': Color(0xFF264653),
    'fragile': Color(0xFFE76F51),
    'heavy': Color(0xFF8B5FBF),
    'document': Color(0xFF4A90E2),
    'default': Color(0xFF95A5A6),
  };

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      url = sp.getString('url') ?? "";

      if (url.isEmpty) {
        setState(() {
          errorMessage = "Configuration error. Please restart app.";
          isLoading = false;
        });
        return;
      }

      var response = await http.get(
        Uri.parse(url + "/view_services"),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == "ok") {
          setState(() {
            services = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Failed to load services";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error. Check connection.";
        isLoading = false;
      });
    }
  }

  Color _getServiceColor(String serviceName) {
    String lowerName = serviceName.toLowerCase();
    for (var entry in categoryColors.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    return categoryColors['default']!;
  }

  IconData _getServiceIcon(String serviceName) {
    String lowerName = serviceName.toLowerCase();
    for (var entry in categoryIcons.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    return categoryIcons['default']!;
  }

  String _getPriceRange(String price) {
    double priceValue = double.tryParse(price) ?? 0;
    if (priceValue < 100) return "Budget";
    if (priceValue < 500) return "Standard";
    if (priceValue < 1000) return "Premium";
    return "Luxury";
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
          "Our Services",
          style: TextStyle(
            fontWeight: FontWeight.w700,
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
              colors: [
                primaryColor,
                secondaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: loadServices,
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadServices,
        color: primaryColor,
        child: isLoading
            ? _buildLoadingState()
            : errorMessage != null
            ? _buildErrorState()
            : services.isEmpty
            ? _buildEmptyState()
            : _buildServiceList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            "Loading amazing services...",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: loadServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Try Again",
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Services Available",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please check back later for new services",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 200,
            height: 50,
            child: OutlinedButton(
              onPressed: loadServices,
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Refresh",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        var service = services[index];
        Color serviceColor = _getServiceColor(service['service_name']);
        IconData serviceIcon = _getServiceIcon(service['service_name']);
        String priceRange = _getPriceRange(service['price']);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(25),
            shadowColor: serviceColor.withOpacity(0.3),
            child: InkWell(
              onTap: () {
                _showServiceDetails(context, service, serviceColor, serviceIcon);
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: serviceColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Icon
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: serviceColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          serviceIcon,
                          size: 35,
                          color: serviceColor,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Service Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    service['service_name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priceColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    priceRange,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: priceColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              service['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "₹",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: serviceColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " ${service['price']}",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: serviceColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Book Button
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        serviceColor,
                                        serviceColor.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: serviceColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookingPage(
                                              serviceId: service['id'].toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Book Now",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
            ),
          ),
        );
      },
    );
  }

  void _showServiceDetails(BuildContext context, var service, Color color, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 30,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['service_name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Service ID: ${service['id']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "₹",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${service['price']}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 120,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  serviceId: service['id'].toString(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Book Now",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}