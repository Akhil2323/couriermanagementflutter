import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryAgentLiveLocation extends StatefulWidget {

  final String bookingId;

  const DeliveryAgentLiveLocation({super.key, required this.bookingId});

  @override
  State<DeliveryAgentLiveLocation> createState() =>
      _DeliveryAgentLiveLocationState();
}

class _DeliveryAgentLiveLocationState extends State<DeliveryAgentLiveLocation> {

  String url = "";

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    url = sp.getString('url') ?? "";

    var response = await http.post(
      Uri.parse(url + "/get_agent_location"),
      body: {"booking_id": widget.bookingId},
    );

    var jsondata = json.decode(response.body);

    if (jsondata['status'] == "ok") {

      double lat = double.parse(jsondata['lat']);
      double lon = double.parse(jsondata['lon']);

      openMap(lat, lon);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not available")),
      );

    }
  }

  Future<void> openMap(double lat, double lon) async {

    final Uri googleMapUrl =
    Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");

    if (await canLaunchUrl(googleMapUrl)) {

      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);

    } else {

      throw "Could not open the map.";

    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(
        child: CircularProgressIndicator(),
      ),

    );
  }
}