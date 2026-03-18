import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String bookingId;
  final String amount;

  const PaymentPage({
    super.key,
    required this.bookingId,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  String amount = "";
  String status = "";
  String date = "";
  String url = "";

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    // Razorpay Listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    loadPayment();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ✅ LOAD PAYMENT DETAILS
  Future<void> loadPayment() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    url = sp.getString("url")!;

    var response = await http.post(
      Uri.parse(url + "/view_payment"),
      body: {
        "booking_id": widget.bookingId,
      },
    );

    var jsondata = json.decode(response.body);

    if (jsondata['status'] == "ok") {
      setState(() {
        amount = jsondata['amount'].toString();
        status = jsondata['payment_status'].toString();
        date = jsondata['date'].toString();
      });
    }
  }

  // ✅ OPEN RAZORPAY
  void openCheckout() {
    if (status == "Paid") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment already completed")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe',
      'amount': (double.parse(amount) * 100).round(),
      'name': 'Courier Management',
      'description': 'Ride Payment',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@gmail.com',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ✅ SUCCESS
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );

    SharedPreferences sp = await SharedPreferences.getInstance();
    String url = sp.getString("url")!;

    // ✅ UPDATE BACKEND STATUS
    await http.post(
      Uri.parse(url + "/update_payment_status/"),
      body: {
        "booking_id": widget.bookingId,
      },
    );

    // ✅ REFRESH UI
    loadPayment();
  }

  // ❌ ERROR
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  // 💳 WALLET
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Payment Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Booking ID"),
                        Text(widget.bookingId),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Amount"),
                        Text("₹ $amount"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status"),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == "Paid"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date"),
                        Text(date),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ✅ BUTTON CONTROL
                    ElevatedButton(
                      onPressed: status == "Paid"
                          ? null
                          : () {
                        openCheckout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status == "Paid"
                            ? Colors.grey
                            : Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        status == "Paid"
                            ? "Already Paid"
                            : "Pay Now",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}