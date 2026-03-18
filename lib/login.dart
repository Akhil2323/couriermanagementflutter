// //
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // import 'register.dart';
// // import 'userhome.dart';
// // import 'deliveryhome.dart';
// //
// // class MyLoginPage extends StatefulWidget {
// // const MyLoginPage({super.key, required this.title});
// // final String title;
// //
// // @override
// // State<MyLoginPage> createState() => _MyLoginPageState();
// // }
// //
// // class _MyLoginPageState extends State<MyLoginPage> {
// // final _formKey = GlobalKey<FormState>();
// // bool _loading = false;
// //
// // final TextEditingController usernameController = TextEditingController();
// // final TextEditingController passwordController = TextEditingController();
// //
// // Future<void> login() async {
// // if (!_formKey.currentState!.validate()) return;
// //
// // setState(() => _loading = true);
// //
// // try {
// // SharedPreferences sp = await SharedPreferences.getInstance();
// // String url = sp.getString('url') ?? '';
// //
// // final response = await http.post(
// // Uri.parse('$url/user_login/'),
// // body: {
// // 'email': usernameController.text.trim(),
// // 'password': passwordController.text.trim(),
// // },
// // );
// //
// // final data = jsonDecode(response.body);
// // setState(() => _loading = false);
// //
// // if (data['status'] == 'ok') {
// // String type = data['type'];
// // String lid = data['lid'].toString();
// //
// // await sp.setBool('isLoggedIn', true);
// // await sp.setString('user_type', type);
// // await sp.setString('lid', lid);
// //
// // // 📍 LOCATION UPDATE ONLY FOR DELIVERY AGENT
// // if (type == 'delivery') {
// // await updateLocation(lid);
// // }
// //
// // if (type == 'customer') {
// // Navigator.pushReplacement(
// // context,
// // MaterialPageRoute(builder: (_) => const UserHome()),
// // );
// // } else if (type == 'delivery') {
// // Navigator.pushReplacement(
// // context,
// // MaterialPageRoute(builder: (_) => const DeliveryHome()),
// // );
// // } else {
// // Fluttertoast.showToast(msg: "Invalid user");
// // }
// // } else {
// // Fluttertoast.showToast(msg: data['message']);
// // }
// // } catch (e) {
// // setState(() => _loading = false);
// // Fluttertoast.showToast(msg: "Error: $e");
// // }
// // }
// //
// // // 📍 UPDATE LOCATION (Delivery Agent Only)
// // Future<void> updateLocation(String lid) async {
// // try {
// // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // if (!serviceEnabled) return;
// //
// // PermissionStatus permission = await Permission.location.request();
// // if (!permission.isGranted) return;
// //
// // Position position = await Geolocator.getCurrentPosition(
// // desiredAccuracy: LocationAccuracy.high);
// //
// // SharedPreferences sp = await SharedPreferences.getInstance();
// // String url = sp.getString('url') ?? '';
// //
// // await http.post(
// // Uri.parse('$url/updatelocation/'),
// // body: {
// // 'lid': lid,
// // 'lat': position.latitude.toString(),
// // 'lon': position.longitude.toString(),
// // },
// // );
// // } catch (e) {
// // debugPrint("Location error: $e");
// // }
// // }
// //
// // @override
// // Widget build(BuildContext context) {
// // return Scaffold(
// // body: Padding(
// // padding: const EdgeInsets.all(20),
// // child: Form(
// // key: _formKey,
// // child: Column(
// // mainAxisAlignment: MainAxisAlignment.center,
// // children: [
// //
// // Text(widget.title,
// // style: const TextStyle(
// // fontSize: 26, fontWeight: FontWeight.bold)),
// //
// // const SizedBox(height: 30),
// //
// // TextFormField(
// // controller: usernameController,
// // decoration: const InputDecoration(
// // labelText: 'Email',
// // border: OutlineInputBorder(),
// // prefixIcon: Icon(Icons.email),
// // ),
// // validator: (v) =>
// // v == null || v.isEmpty ? 'Email required' : null,
// // ),
// //
// // const SizedBox(height: 15),
// //
// // TextFormField(
// // controller: passwordController,
// // decoration: const InputDecoration(
// // labelText: 'Password',
// // border: OutlineInputBorder(),
// // prefixIcon: Icon(Icons.lock),
// // ),
// // obscureText: true,
// // validator: (v) =>
// // v == null || v.isEmpty ? 'Password required' : null,
// // ),
// //
// // const SizedBox(height: 25),
// //
// // SizedBox(
// // width: double.infinity,
// // height: 50,
// // child: ElevatedButton(
// // onPressed: _loading ? null : login,
// // child: _loading
// // ? const CircularProgressIndicator(color: Colors.white)
// //     : const Text('LOGIN'),
// // ),
// // ),
// //
// // const SizedBox(height: 25),
// //
// // const Text("Don't have an account?"),
// //
// // const SizedBox(height: 10),
// //
// // // ✅ ONLY CUSTOMER REGISTER
// // SizedBox(
// // width: double.infinity,
// // child: OutlinedButton(
// // child: const Text('Create Customer Account'),
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (_) => const MyMySignup(),
// // ),
// // );
// // },
// // ),
// // ),
// // ],
// // ),
// // ),
// // ),
// // );
// // }
// // }
// //
//
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'register.dart';
// import 'userhome.dart';
// import 'deliveryhome.dart';
//
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _loading = false;
//   bool _obscurePassword = true;
//
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   Future<void> login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _loading = true);
//
//     try {
//       SharedPreferences sp = await SharedPreferences.getInstance();
//       String url = sp.getString('url') ?? '';
//
//       final response = await http.post(
//         Uri.parse('$url/user_login/'),
//         body: {
//           'email': usernameController.text.trim(),
//           'password': passwordController.text.trim(),
//         },
//       );
//
//       final data = jsonDecode(response.body);
//       setState(() => _loading = false);
//
//       if (data['status'] == 'ok') {
//         String type = data['type'];
//         String lid = data['lid'].toString();
//
//         await sp.setBool('isLoggedIn', true);
//         await sp.setString('user_type', type);
//         await sp.setString('lid', lid);
//
//         // 📍 LOCATION UPDATE ONLY FOR DELIVERY AGENT
//         if (type == 'delivery') {
//           await updateLocation(lid);
//         }
//
//         if (type == 'customer') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const UserHome()),
//           );
//         } else if (type == 'delivery') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const DeliveryHome()),
//           );
//         } else {
//           Fluttertoast.showToast(msg: "Invalid user");
//         }
//       } else {
//         Fluttertoast.showToast(msg: data['message']);
//       }
//     } catch (e) {
//       setState(() => _loading = false);
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   // 📍 UPDATE LOCATION (Delivery Agent Only)
//   Future<void> updateLocation(String lid) async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;
//
//       PermissionStatus permission = await Permission.location.request();
//       if (!permission.isGranted) return;
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//
//       SharedPreferences sp = await SharedPreferences.getInstance();
//       String url = sp.getString('url') ?? '';
//
//       await http.post(
//         Uri.parse('$url/updatelocation/'),
//         body: {
//           'lid': lid,
//           'lat': position.latitude.toString(),
//           'lon': position.longitude.toString(),
//         },
//       );
//     } catch (e) {
//       debugPrint("Location error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Logo or Icon
//                     Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.shopping_bag_outlined,
//                         size: 50,
//                         color: Colors.blue,
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Title
//                     Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Subtitle
//                     Text(
//                       'Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//
//                     const SizedBox(height: 40),
//
//                     // Email Field
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 10,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: TextFormField(
//                         controller: usernameController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           hintText: 'Enter your email',
//                           prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         validator: (v) =>
//                         v == null || v.isEmpty ? 'Email required' : null,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Password Field
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 10,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: TextFormField(
//                         controller: passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           hintText: 'Enter your password',
//                           prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 16,
//                           ),
//                         ),
//                         obscureText: _obscurePassword,
//                         validator: (v) =>
//                         v == null || v.isEmpty ? 'Password required' : null,
//                       ),
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     // Login Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton(
//                         onPressed: _loading ? null : login,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           elevation: 3,
//                           shadowColor: Colors.blue.withOpacity(0.4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: _loading
//                             ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                             : const Text(
//                           'LOGIN',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 25),
//
//                     // Divider
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Divider(
//                             color: Colors.grey.shade300,
//                             thickness: 1,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             "Don't have an account?",
//                             style: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             color: Colors.grey.shade300,
//                             thickness: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 25),
//
//                     // Register Button - ONLY CUSTOMER REGISTER
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const MyMySignup(),
//                             ),
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.blue,
//                           side: BorderSide(color: Colors.blue.shade200, width: 1.5),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'Create Customer Account',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Delivery Agent Note
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.orange.shade200),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             size: 18,
//                             color: Colors.orange.shade800,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'Delivery agents will be prompted for location access',
//                               style: TextStyle(
//                                 color: Colors.orange.shade800,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'register.dart';
import 'userhome.dart';
import 'deliveryhome.dart';
import 'forgotpassword.dart'; // You'll need to create this file

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscurePassword = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String url = sp.getString('url') ?? '';

      final response = await http.post(
        Uri.parse('$url/user_login/'),
        body: {
          'email': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);
      setState(() => _loading = false);

      if (data['status'] == 'ok') {
        String type = data['type'];
        String lid = data['lid'].toString();

        await sp.setBool('isLoggedIn', true);
        await sp.setString('user_type', type);
        await sp.setString('lid', lid);

        // 📍 LOCATION UPDATE ONLY FOR DELIVERY AGENT
        if (type == 'delivery') {
          await updateLocation(lid);
        }

        if (type == 'customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserHome()),
          );
        } else if (type == 'delivery') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DeliveryHome()),
          );
        } else {
          Fluttertoast.showToast(msg: "Invalid user");
        }
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // 📍 UPDATE LOCATION (Delivery Agent Only)
  Future<void> updateLocation(String lid) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      PermissionStatus permission = await Permission.location.request();
      if (!permission.isGranted) return;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      SharedPreferences sp = await SharedPreferences.getInstance();
      String url = sp.getString('url') ?? '';

      await http.post(
        Uri.parse('$url/updatelocation/'),
        body: {
          'lid': lid,
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
        },
      );
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo or Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Email required' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Password required' : null,
                      ),
                    ),

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
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

                    const SizedBox(height: 25),

                    // Register Button - ONLY CUSTOMER REGISTER
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyMySignup(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue.shade200, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create Customer Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Delivery Agent Note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.orange.shade800,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Delivery agents will be prompted for location access',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 12,
                              ),
                            ),
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
      ),
    );
  }
}