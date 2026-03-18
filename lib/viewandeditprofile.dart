// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class ViewEditProfile extends StatefulWidget {
//   const ViewEditProfile({super.key});
//
//   @override
//   State<ViewEditProfile> createState() => _ViewEditProfileState();
// }
//
// class _ViewEditProfileState extends State<ViewEditProfile> {
//
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//
//   String url = "";
//   String lid = "";
//   bool isEditing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadProfile();
//   }
//
//   Future<void> loadProfile() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     url = sp.getString('url') ?? "";
//     lid = sp.getString('lid') ?? "";
//
//     var response = await http.post(
//       Uri.parse(url + "/user_view_profile"),
//       body: {"lid": lid},
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       setState(() {
//         nameController.text = jsonData['name'];
//         phoneController.text = jsonData['phone'];
//         emailController.text = jsonData['email'];
//         addressController.text = jsonData['address'];
//       });
//     }
//   }
//
//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     var response = await http.post(
//       Uri.parse(url + "/user_edit_profile"),
//       body: {
//         "lid": lid,
//         "name": nameController.text,
//         "phone": phoneController.text,
//         "address": addressController.text,
//       },
//     );
//
//     var jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == "ok") {
//       Fluttertoast.showToast(msg: "Profile Updated Successfully");
//       setState(() {
//         isEditing = false;
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Update Failed");
//     }
//   }
//
//   InputDecoration inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("My Profile"),
//         backgroundColor: Colors.teal,
//         actions: [
//           if (!isEditing)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 setState(() {
//                   isEditing = true;
//                 });
//               },
//             )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//
//             // 🔹 Profile Header
//             CircleAvatar(
//               radius: 45,
//               backgroundColor: Colors.teal,
//               child: Text(
//                 nameController.text.isNotEmpty
//                     ? nameController.text[0].toUpperCase()
//                     : "U",
//                 style: const TextStyle(fontSize: 32, color: Colors.white),
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             Text(
//               nameController.text,
//               style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // 🔹 Profile Card
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//
//                       TextFormField(
//                         controller: nameController,
//                         enabled: isEditing,
//                         decoration: inputDecoration("Name"),
//                         validator: (value) =>
//                         value!.isEmpty ? "Enter name" : null,
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       TextFormField(
//                         controller: phoneController,
//                         enabled: isEditing,
//                         keyboardType: TextInputType.phone,
//                         decoration: inputDecoration("Phone"),
//                         validator: (value) =>
//                         value!.isEmpty ? "Enter phone" : null,
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       TextFormField(
//                         controller: emailController,
//                         enabled: false,
//                         decoration: inputDecoration("Email").copyWith(
//                           fillColor: Colors.grey.shade200,
//                         ),
//                       ),
//
//                       const SizedBox(height: 15),
//
//                       TextFormField(
//                         controller: addressController,
//                         enabled: isEditing,
//                         maxLines: 3,
//                         decoration: inputDecoration("Address"),
//                         validator: (value) =>
//                         value!.isEmpty ? "Enter address" : null,
//                       ),
//
//                       const SizedBox(height: 25),
//
//                       if (isEditing)
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey),
//                               onPressed: () {
//                                 setState(() {
//                                   isEditing = false;
//                                   loadProfile(); // revert changes
//                                 });
//                               },
//                               child: const Text("Cancel"),
//                             ),
//
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.teal),
//                               onPressed: updateProfile,
//                               child: const Text("Save"),
//                             ),
//
//                           ],
//                         ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewEditProfile extends StatefulWidget {
  const ViewEditProfile({super.key});

  @override
  State<ViewEditProfile> createState() => _ViewEditProfileState();
}

class _ViewEditProfileState extends State<ViewEditProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String url = "";
  String lid = "";
  bool isEditing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() => isLoading = true);

    SharedPreferences sp = await SharedPreferences.getInstance();
    url = sp.getString('url') ?? "";
    lid = sp.getString('lid') ?? "";

    try {
      var response = await http.post(
        Uri.parse(url + "/user_view_profile"),
        body: {"lid": lid},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "ok") {
        setState(() {
          nameController.text = jsonData['name'] ?? '';
          phoneController.text = jsonData['phone'] ?? '';
          emailController.text = jsonData['email'] ?? '';
          addressController.text = jsonData['address'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "Failed to load profile");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: "Error loading profile");
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      var response = await http.post(
        Uri.parse(url + "/user_edit_profile"),
        body: {
          "lid": lid,
          "name": nameController.text,
          "phone": phoneController.text,
          "address": addressController.text,
        },
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "ok") {
        Fluttertoast.showToast(msg: "Profile Updated Successfully");
        setState(() {
          isEditing = false;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "Update Failed");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: "Error updating profile");
    }
  }

  InputDecoration inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
      filled: true,
      fillColor: isEditing ? Colors.white : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isEditing && !isLoading)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                tooltip: 'Edit Profile',
              ),
            )
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Background
            Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

            // Profile Section (overlapping)
            Transform.translate(
              offset: const Offset(0, -70),
              child: Column(
                children: [
                  // Profile Avatar with Border
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        nameController.text.isNotEmpty
                            ? nameController.text[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // User Name
                  Text(
                    nameController.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  // Email Badge
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email_outlined,
                            size: 16, color: Colors.teal.shade700),
                        const SizedBox(width: 6),
                        Text(
                          emailController.text,
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditing)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Edit Your Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ),

                        // Name Field
                        TextFormField(
                          controller: nameController,
                          enabled: isEditing,
                          decoration: inputDecoration(
                            "Full Name",
                            icon: Icons.person_outline,
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "Enter your name" : null,
                        ),

                        const SizedBox(height: 18),

                        // Phone Field
                        TextFormField(
                          controller: phoneController,
                          enabled: isEditing,
                          keyboardType: TextInputType.phone,
                          decoration: inputDecoration(
                            "Phone Number",
                            icon: Icons.phone_outlined,
                          ),
                          validator: (value) => value!.isEmpty
                              ? "Enter your phone number"
                              : null,
                        ),

                        const SizedBox(height: 18),

                        // Email Field (disabled)
                        TextFormField(
                          controller: emailController,
                          enabled: false,
                          decoration: inputDecoration(
                            "Email Address",
                            icon: Icons.email_outlined,
                          ).copyWith(
                            fillColor: Colors.grey.shade100,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Address Field
                        TextFormField(
                          controller: addressController,
                          enabled: isEditing,
                          maxLines: 3,
                          minLines: 2,
                          decoration: inputDecoration(
                            "Address",
                            icon: Icons.location_on_outlined,
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "Enter your address" : null,
                        ),

                        const SizedBox(height: 30),

                        // Action Buttons
                        if (isEditing)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey.shade700,
                                    side: BorderSide(
                                        color: Colors.grey.shade300),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEditing = false;
                                      loadProfile(); // revert changes
                                    });
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: updateProfile,
                                  child: const Text("Save Changes"),
                                ),
                              ),
                            ],
                          ),

                        if (!isEditing)
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              icon: const Icon(Icons.edit,
                                  color: Colors.teal),
                              label: Text(
                                "Tap to Edit Profile",
                                style: TextStyle(
                                  color: Colors.teal.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Additional Info Card (Optional)
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 0,
                  color: Colors.teal.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified,
                            size: 18, color: Colors.teal.shade600),
                        const SizedBox(width: 8),
                        Text(
                          "Profile information is secure",
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
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
    super.dispose();
  }
}