import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyMySignup extends StatefulWidget {
  const MyMySignup({super.key});

  @override
  State<MyMySignup> createState() => _MyMySignupState();
}

class _MyMySignupState extends State<MyMySignup> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🔥 REGISTER FUNCTION
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String url = sp.getString('url') ?? '';

      if (url.isEmpty) {
        Fluttertoast.showToast(msg: "Server URL not set");
        setState(() => _loading = false);
        return;
      }

      var response = await http.post(
        Uri.parse('$url/user_register/'),
        body: {
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Registration Successful");
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: data['message'] ?? "Registration Failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Server Error");
      }
    } catch (e) {
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Widget buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildTextField("Name", nameController, Icons.person),
              buildTextField("Phone", phoneController, Icons.phone),
              buildTextField("Email", emailController, Icons.email),
              buildTextField("Address", addressController, Icons.home),
              buildTextField("Password", passwordController, Icons.lock,
                  isPassword: true),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}