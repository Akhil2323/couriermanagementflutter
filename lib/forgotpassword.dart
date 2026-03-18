import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final TextEditingController emailController = TextEditingController();

  bool loading = false;

  Future<void> sendPassword() async {

    if(emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter email");
      return;
    }

    setState(() {
      loading = true;
    });

    try{

      SharedPreferences sp = await SharedPreferences.getInstance();
      String url = sp.getString('url') ?? '';

      final response = await http.post(
          Uri.parse('$url/forgot_password/'),
          body: {
            'email': emailController.text.trim()
          }
      );

      var data = jsonDecode(response.body);

      setState(() {
        loading = false;
      });

      if(data['status'] == 'ok'){

        Fluttertoast.showToast(
            msg: data['message']
        );

        Navigator.pop(context);

      }else{

        Fluttertoast.showToast(
            msg: data['message']
        );

      }

    }catch(e){

      setState(() {
        loading = false;
      });

      Fluttertoast.showToast(msg: "Server error");

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.blue,
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(25),

            child: Column(

              children: [

                const Icon(
                  Icons.lock_reset,
                  size: 90,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Reset Password",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter your registered email.\nA new password will be sent to your email.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                TextField(

                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(

                    labelText: "Email",

                    prefixIcon: const Icon(Icons.email),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),

                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: loading ? null : sendPassword,

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),

                    child: loading
                        ? const CircularProgressIndicator(
                        color: Colors.white
                    )
                        : const Text(
                      "Send New Password",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}