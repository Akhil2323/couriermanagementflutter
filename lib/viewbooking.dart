// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'live_map.dart';
//
// class ViewMyBookings extends StatefulWidget {
//   const ViewMyBookings({super.key});
//
//   @override
//   State<ViewMyBookings> createState() => _ViewMyBookingsState();
// }
//
// class _ViewMyBookingsState extends State<ViewMyBookings> {
//   List bookings = [];
//   String url = "";
//   String lid = "";
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
//     var response = await http.post(
//       Uri.parse("$url/view_my_bookings"),
//       body: {"lid": lid},
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         bookings = jsonData['data'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         backgroundColor: Colors.teal,
//       ),
//       body: bookings.isEmpty
//           ? const Center(child: Text("No Bookings Found"))
//           : ListView.builder(
//         itemCount: bookings.length,
//         itemBuilder: (context, index) {
//           var b = bookings[index];
//
//           return Card(
//             margin: const EdgeInsets.all(10),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     b['service_name'],
//                     style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal),
//                   ),
//                   const SizedBox(height: 10),
//                   Text("📦 Weight : ${b['package_weight']} kg"),
//                   Text("📅 Date : ${b['booking_date']}"),
//                   const Divider(),
//                   Text("📍 Sender Address: ${b['sender_address']}"),
//                   const SizedBox(height: 8),
//                   Text("👤 Receiver: ${b['receiver_name']}"),
//                   Text("📍 Receiver Address: ${b['receiver_address']}"),
//                   const SizedBox(height: 10),
//                   Text(
//                     "🚚 Delivery Agent: ${b['delivery_agent']}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//
//                   // SHOW LAST UPDATED LOCATION BUTTON
//                   if (b['delivery_agent'] != "Not Assigned")
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.location_on),
//                         label: const Text("View Last Location"),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   DeliveryAgentLiveLocation(
//                                     bookingId: b['id'].toString(),
//                                   ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
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
import 'live_map.dart';
import 'viewpayement.dart';

class ViewMyBookings extends StatefulWidget {
  const ViewMyBookings({super.key});

  @override
  State<ViewMyBookings> createState() => _ViewMyBookingsState();
}

class _ViewMyBookingsState extends State<ViewMyBookings> {

  List bookings = [];
  String url = "";
  String lid = "";

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    url = sp.getString('url') ?? "";
    lid = sp.getString('lid') ?? "";

    var response = await http.post(
      Uri.parse("$url/view_my_bookings"),
      body: {"lid": lid},
    );

    var jsonData = json.decode(response.body);

    if (jsonData['status'] == "ok") {

      setState(() {
        bookings = jsonData['data'];
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.teal,
      ),

      body: bookings.isEmpty
          ? const Center(child: Text("No Bookings Found"))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {

          var b = bookings[index];

          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    b['service_name'],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),

                  const SizedBox(height: 10),

                  Text("📦 Weight : ${b['package_weight']} kg"),
                  Text("📅 Date : ${b['booking_date']}"),

                  const Divider(),

                  Text("📍 Sender Address: ${b['sender_address']}"),

                  const SizedBox(height: 8),

                  Text("👤 Receiver: ${b['receiver_name']}"),
                  Text("📍 Receiver Address: ${b['receiver_address']}"),

                  const SizedBox(height: 10),

                  Text(
                    "🚚 Delivery Agent: ${b['delivery_agent']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      /// PAYMENT BUTTON
                      Expanded(
                        child: ElevatedButton.icon(

                          icon: const Icon(Icons.payment),

                          label: const Text("Payment"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),

                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  bookingId: b['id'].toString(),
                                  amount: b['amount'].toString(),
                                ),
                              ),
                            );

                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// MAP BUTTON
                      if (b['delivery_agent'] != "Not Assigned")
                        Expanded(
                          child: ElevatedButton.icon(

                            icon: const Icon(Icons.map),

                            label: const Text("Track"),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeliveryAgentLiveLocation(
                                        bookingId: b['id'].toString(),
                                      ),
                                ),
                              );

                            },
                          ),
                        ),

                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}