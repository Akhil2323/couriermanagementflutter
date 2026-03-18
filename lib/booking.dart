// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// //
// // class BookingPage extends StatefulWidget {
// //   final String serviceId;
// //
// //   const BookingPage({super.key, required this.serviceId});
// //
// //   @override
// //   State<BookingPage> createState() => _BookingPageState();
// // }
// //
// // class _BookingPageState extends State<BookingPage> {
// //
// //   final _formKey = GlobalKey<FormState>();
// //
// //   TextEditingController senderController = TextEditingController();
// //   TextEditingController receiverNameController = TextEditingController();
// //   TextEditingController receiverPhoneController = TextEditingController();
// //   TextEditingController receiverAddressController = TextEditingController();
// //   TextEditingController weightController = TextEditingController();
// //
// //   String url = "";
// //   String lid = "";
// //
// //   Future<void> bookService() async {
// //
// //     if (!_formKey.currentState!.validate()) return;
// //
// //     SharedPreferences sp = await SharedPreferences.getInstance();
// //     url = sp.getString('url') ?? "";
// //     lid = sp.getString('lid') ?? "";
// //
// //     var response = await http.post(
// //       Uri.parse(url + "/book_service"),
// //       body: {
// //         "lid": lid,
// //         "service_id": widget.serviceId,
// //         "sender_address": senderController.text,
// //         "receiver_name": receiverNameController.text,
// //         "receiver_phone": receiverPhoneController.text,
// //         "receiver_address": receiverAddressController.text,
// //         "package_weight": weightController.text,
// //       },
// //     );
// //
// //     var jsonData = json.decode(response.body);
// //
// //     if (jsonData['status'] == "ok") {
// //       Fluttertoast.showToast(msg: "Booking Successful");
// //       Navigator.pop(context);
// //     } else {
// //       Fluttertoast.showToast(msg: "Booking Failed");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Book Service"),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: SingleChildScrollView(
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               children: [
// //
// //                 TextFormField(
// //                   controller: senderController,
// //                   decoration: const InputDecoration(
// //                       labelText: "Sender Address",
// //                       border: OutlineInputBorder()),
// //                   maxLines: 2,
// //                   validator: (value) =>
// //                   value!.isEmpty ? "Enter sender address" : null,
// //                 ),
// //
// //                 const SizedBox(height: 15),
// //
// //                 TextFormField(
// //                   controller: receiverNameController,
// //                   decoration: const InputDecoration(
// //                       labelText: "Receiver Name",
// //                       border: OutlineInputBorder()),
// //                   validator: (value) =>
// //                   value!.isEmpty ? "Enter receiver name" : null,
// //                 ),
// //
// //                 const SizedBox(height: 15),
// //
// //                 TextFormField(
// //                   controller: receiverPhoneController,
// //                   keyboardType: TextInputType.phone,
// //                   decoration: const InputDecoration(
// //                       labelText: "Receiver Phone",
// //                       border: OutlineInputBorder()),
// //                   validator: (value) =>
// //                   value!.isEmpty ? "Enter receiver phone" : null,
// //                 ),
// //
// //                 const SizedBox(height: 15),
// //
// //                 TextFormField(
// //                   controller: receiverAddressController,
// //                   decoration: const InputDecoration(
// //                       labelText: "Receiver Address",
// //                       border: OutlineInputBorder()),
// //                   maxLines: 2,
// //                   validator: (value) =>
// //                   value!.isEmpty ? "Enter receiver address" : null,
// //                 ),
// //
// //                 const SizedBox(height: 15),
// //
// //                 TextFormField(
// //                   controller: weightController,
// //                   decoration: const InputDecoration(
// //                       labelText: "Package Weight (kg)",
// //                       border: OutlineInputBorder()),
// //                   validator: (value) =>
// //                   value!.isEmpty ? "Enter package weight" : null,
// //                 ),
// //
// //                 const SizedBox(height: 25),
// //
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 50,
// //                   child: ElevatedButton(
// //                     onPressed: bookService,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.teal,
// //                     ),
// //                     child: const Text(
// //                       "Confirm Booking",
// //                       style: TextStyle(fontSize: 16),
// //                     ),
// //                   ),
// //                 )
// //
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class BookingPage extends StatefulWidget {
//   final String serviceId;
//
//   const BookingPage({super.key, required this.serviceId});
//
//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }
//
// class _BookingPageState extends State<BookingPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController senderController = TextEditingController();
//   TextEditingController receiverNameController = TextEditingController();
//   TextEditingController receiverPhoneController = TextEditingController();
//   TextEditingController receiverAddressController = TextEditingController();
//   TextEditingController weightController = TextEditingController();
//
//   String url = "";
//   String lid = "";
//   bool isLoading = false;
//
//   // Color palette
//   static const Color primaryColor = Color(0xFF00897B); // Teal
//   static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
//   static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
//   static const Color backgroundColor = Color(0xFFF5F5F5);
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     setState(() {
//       url = sp.getString('url') ?? "";
//       lid = sp.getString('lid') ?? "";
//     });
//   }
//
//   Future<void> bookService() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       SharedPreferences sp = await SharedPreferences.getInstance();
//       url = sp.getString('url') ?? "";
//       lid = sp.getString('lid') ?? "";
//
//       var response = await http.post(
//         Uri.parse(url + "/book_service"),
//         body: {
//           "lid": lid,
//           "service_id": widget.serviceId,
//           "sender_address": senderController.text,
//           "receiver_name": receiverNameController.text,
//           "receiver_phone": receiverPhoneController.text,
//           "receiver_address": receiverAddressController.text,
//           "package_weight": weightController.text,
//         },
//       ).timeout(const Duration(seconds: 10));
//
//       var jsonData = json.decode(response.body);
//
//       setState(() {
//         isLoading = false;
//       });
//
//       if (jsonData['status'] == "ok") {
//         Fluttertoast.showToast(
//           msg: "Booking Successful!",
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           gravity: ToastGravity.TOP,
//         );
//
//         // Show success dialog before popping
//         _showSuccessDialog();
//       } else {
//         Fluttertoast.showToast(
//           msg: "Booking Failed. Please try again.",
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           gravity: ToastGravity.TOP,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(
//         msg: "Network error. Check your connection.",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         gravity: ToastGravity.TOP,
//       );
//     }
//   }
//
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Icon(
//             Icons.check_circle,
//             color: Colors.green,
//             size: 60,
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Text(
//                 "Booking Confirmed!",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Your service has been booked successfully.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 Navigator.pop(context); // Go back to previous screen
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: primaryColor,
//               ),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   InputDecoration _buildInputDecoration({
//     required String label,
//     required IconData icon,
//     String? helperText,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       helperText: helperText,
//       prefixIcon: Icon(icon, color: primaryColor),
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: const BorderSide(color: primaryColor, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide(color: Colors.red.shade300, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 16,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         title: const Text(
//           "Book Service",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [primaryColor, secondaryColor],
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//         ),
//       )
//           : SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       primaryColor.withOpacity(0.1),
//                       accentColor.withOpacity(0.05),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: primaryColor.withOpacity(0.2),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.local_shipping,
//                       size: 50,
//                       color: primaryColor,
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Booking Details",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       "Service ID: ${widget.serviceId}",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // Sender Information Section
//               _buildSectionHeader(
//                 title: "Sender Information",
//                 icon: Icons.person_outline,
//               ),
//               const SizedBox(height: 15),
//
//               // Sender Address
//               TextFormField(
//                 controller: senderController,
//                 maxLines: 3,
//                 minLines: 2,
//                 decoration: _buildInputDecoration(
//                   label: "Sender Address",
//                   icon: Icons.location_on_outlined,
//                   helperText: "Your current pickup address",
//                 ),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter sender address" : null,
//               ),
//
//               const SizedBox(height: 25),
//
//               // Receiver Information Section
//               _buildSectionHeader(
//                 title: "Receiver Information",
//                 icon: Icons.person_outline,
//               ),
//               const SizedBox(height: 15),
//
//               // Receiver Name
//               TextFormField(
//                 controller: receiverNameController,
//                 decoration: _buildInputDecoration(
//                   label: "Receiver Name",
//                   icon: Icons.person_outline,
//                 ),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter receiver name" : null,
//               ),
//
//               const SizedBox(height: 15),
//
//               // Receiver Phone
//               TextFormField(
//                 controller: receiverPhoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: _buildInputDecoration(
//                   label: "Receiver Phone",
//                   icon: Icons.phone_outlined,
//                   helperText: "10-digit mobile number",
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter receiver phone";
//                   }
//                   if (value.length != 10) {
//                     return "Phone number must be 10 digits";
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 15),
//
//               // Receiver Address
//               TextFormField(
//                 controller: receiverAddressController,
//                 maxLines: 3,
//                 minLines: 2,
//                 decoration: _buildInputDecoration(
//                   label: "Receiver Address",
//                   icon: Icons.location_on_outlined,
//                 ),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter receiver address" : null,
//               ),
//
//               const SizedBox(height: 25),
//
//               // Package Details Section
//               _buildSectionHeader(
//                 title: "Package Details",
//                 icon: Icons.inventory_outlined,
//               ),
//               const SizedBox(height: 15),
//
//               // Package Weight
//               TextFormField(
//                 controller: weightController,
//                 keyboardType: TextInputType.number,
//                 decoration: _buildInputDecoration(
//                   label: "Package Weight",
//                   icon: Icons.fitness_center_outlined,
//                   helperText: "Enter weight in kilograms",
//                 ).copyWith(
//                   suffixText: "kg",
//                   suffixStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter package weight";
//                   }
//                   if (double.tryParse(value) == null) {
//                     return "Please enter a valid number";
//                   }
//                   if (double.parse(value) <= 0) {
//                     return "Weight must be greater than 0";
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 30),
//
//               // Summary Card (Optional - shows calculated info)
//               Card(
//                 elevation: 0,
//                 color: accentColor.withOpacity(0.1),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   side: BorderSide(
//                     color: primaryColor.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: primaryColor.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.info_outline,
//                           color: primaryColor,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Booking Summary",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Please verify all details before confirming",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // Confirm Booking Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : bookService,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     foregroundColor: Colors.white,
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Colors.white,
//                       ),
//                     ),
//                   )
//                       : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text(
//                         "Confirm Booking",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(Icons.arrow_forward),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Terms and Conditions
//               Center(
//                 child: Text(
//                   "By booking, you agree to our terms and conditions",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader({required String title, required IconData icon}) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: primaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: primaryColor, size: 20),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     senderController.dispose();
//     receiverNameController.dispose();
//     receiverPhoneController.dispose();
//     receiverAddressController.dispose();
//     weightController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'viewpayement.dart';

class BookingPage extends StatefulWidget {
  final String serviceId;

  const BookingPage({super.key, required this.serviceId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController senderController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverAddressController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String url = "";
  String lid = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    url = sp.getString("url") ?? "";
    lid = sp.getString("lid") ?? "";
  }

  Future<void> bookService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
      Uri.parse(url + "/book_service"),
      body: {
        "lid": lid,
        "service_id": widget.serviceId,
        "sender_address": senderController.text,
        "receiver_name": receiverNameController.text,
        "receiver_phone": receiverPhoneController.text,
        "receiver_address": receiverAddressController.text,
        "package_weight": weightController.text,
      },
    );

    var jsondata = json.decode(response.body);

    setState(() {
      isLoading = false;
    });

    if (jsondata['status'] == "ok") {
      String bookingId = jsondata['booking_id'].toString();
      String amount = jsondata['amount'].toString();

      _showSuccessDialog(bookingId, amount);
    } else {
      Fluttertoast.showToast(msg: "Booking Failed");
    }
  }

  void _showSuccessDialog(String bookingId, String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Successful"),
          content: const Text(
              "Your courier booking was successful.\nClick below to view payment."),
          actions: [
            ElevatedButton(
              child: const Text("View Payment"),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      bookingId: bookingId,
                      amount: amount,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Courier Service"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: senderController,
                decoration:
                const InputDecoration(labelText: "Sender Address"),
                validator: (value) =>
                value!.isEmpty ? "Enter sender address" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: receiverNameController,
                decoration:
                const InputDecoration(labelText: "Receiver Name"),
                validator: (value) =>
                value!.isEmpty ? "Enter receiver name" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: receiverPhoneController,
                decoration:
                const InputDecoration(labelText: "Receiver Phone"),
                validator: (value) =>
                value!.isEmpty ? "Enter phone number" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: receiverAddressController,
                decoration: const InputDecoration(
                    labelText: "Receiver Address"),
                validator: (value) =>
                value!.isEmpty ? "Enter address" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: weightController,
                decoration:
                const InputDecoration(labelText: "Package Weight"),
                validator: (value) =>
                value!.isEmpty ? "Enter weight" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: bookService,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal),
                child: const Text("Confirm Booking"),
              )
            ],
          ),
        ),
      ),
    );
  }
}