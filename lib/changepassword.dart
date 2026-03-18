// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'userhome.dart';
// import 'login.dart';
// import 'deliveryhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class ChangePassword extends StatefulWidget {
//   const ChangePassword({super.key});
//
//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }
//
// class _ChangePasswordState extends State<ChangePassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _cpasswordController = TextEditingController();
//   final TextEditingController _npasswordController = TextEditingController();
//   final TextEditingController _conpasswordController = TextEditingController();
//
//   bool _obscureCurrent = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//   bool _isLoading = false;
//   String _errorMessage = '';
//
//   // ================= BACK NAVIGATION =================
//   Future<void> _goToHome() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? role = sh.getString("role");
//
//     if (role == "user") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const UserHome()),
//       );
//     } else if (role == "delivery") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DeliveryHome()),
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   // ================= CHANGE PASSWORD =================
//   Future<void> _sendData() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     String current = _cpasswordController.text;
//     String newPass = _npasswordController.text;
//     String confirm = _conpasswordController.text;
//
//     if (newPass == current) {
//       setState(() => _errorMessage =
//       "New password must be different from current password");
//       return;
//     }
//
//     if (newPass.length < 8 ||
//         !RegExp(r'[A-Z]').hasMatch(newPass) ||
//         !RegExp(r'[a-z]').hasMatch(newPass) ||
//         !RegExp(r'[0-9]').hasMatch(newPass) ||
//         !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(newPass)) {
//       setState(() => _errorMessage = "Password does not meet requirements");
//       return;
//     }
//
//     if (newPass != confirm) {
//       setState(() => _errorMessage = "Passwords do not match");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//
//     try {
//       final uri = Uri.parse('$url/fluttchangepassword/');
//       var request = http.MultipartRequest('POST', uri);
//
//       request.fields['ucpassword'] = current;
//       request.fields['unpassword'] = newPass;
//       request.fields['uconpassword'] = confirm;
//       request.fields['lid'] = lid.toString();
//
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (data['status'] == 'ok') {
//         Fluttertoast.showToast(
//           msg: "Password changed successfully!",
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//
//         _cpasswordController.clear();
//         _npasswordController.clear();
//         _conpasswordController.clear();
//
//         await Future.delayed(const Duration(seconds: 2));
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MyLoginPage(title: "")),
//         );
//       } else {
//         setState(() {
//           _errorMessage = data['message'] ?? "Failed to change password";
//         });
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Network error");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   // ================= UI =================
//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscure,
//     required VoidCallback toggle,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         validator: (value) =>
//         value == null || value.isEmpty ? "Required field" : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           prefixIcon: const Icon(Icons.lock_outline),
//           suffixIcon: IconButton(
//             icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
//             onPressed: toggle,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _goToHome();
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Change Password"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: _goToHome,
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//
//                 _buildPasswordField(
//                   controller: _cpasswordController,
//                   label: "Current Password",
//                   obscure: _obscureCurrent,
//                   toggle: () =>
//                       setState(() => _obscureCurrent = !_obscureCurrent),
//                 ),
//
//                 _buildPasswordField(
//                   controller: _npasswordController,
//                   label: "New Password",
//                   obscure: _obscureNew,
//                   toggle: () => setState(() => _obscureNew = !_obscureNew),
//                 ),
//
//                 _buildPasswordField(
//                   controller: _conpasswordController,
//                   label: "Confirm Password",
//                   obscure: _obscureConfirm,
//                   toggle: () =>
//                       setState(() => _obscureConfirm = !_obscureConfirm),
//                 ),
//
//                 if (_errorMessage.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text(
//                       _errorMessage,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//
//                 const SizedBox(height: 20),
//
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _sendData,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(
//                         color: Colors.white)
//                         : const Text("Change Password"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'userhome.dart';
import 'login.dart';
import 'deliveryhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _npasswordController = TextEditingController();
  final TextEditingController _conpasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _errorMessage = '';
  String _userRole = '';
  String _userName = '';

  // Color palette
  static const Color primaryColor = Color(0xFF00897B); // Teal
  static const Color secondaryColor = Color(0xFF00695C); // Darker Teal
  static const Color accentColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color successColor = Color(0xFF66BB6A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      _userRole = sh.getString("role") ?? '';
      _userName = sh.getString("user_name") ?? sh.getString("agent_name") ?? 'User';
    });
  }

  // ================= BACK NAVIGATION =================
  Future<void> _goToHome() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? role = sh.getString("role");

    if (role == "user") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHome()),
      );
    } else if (role == "delivery") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeliveryHome()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  // ================= PASSWORD VALIDATION =================
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Include at least one uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Include at least one lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Include at least one number";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Include at least one special character";
    }

    return null;
  }

  // ================= CHANGE PASSWORD =================
  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) return;

    String current = _cpasswordController.text;
    String newPass = _npasswordController.text;
    String confirm = _conpasswordController.text;

    // Check if new password is same as current
    if (newPass == current) {
      setState(() => _errorMessage = "New password must be different from current password");
      return;
    }

    // Check if new password meets requirements
    String? passwordError = _validatePassword(newPass);
    if (passwordError != null) {
      setState(() => _errorMessage = passwordError);
      return;
    }

    // Check if passwords match
    if (newPass != confirm) {
      setState(() => _errorMessage = "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    try {
      final uri = Uri.parse('$url/fluttchangepassword/');
      var request = http.MultipartRequest('POST', uri);

      request.fields['ucpassword'] = current;
      request.fields['unpassword'] = newPass;
      request.fields['uconpassword'] = confirm;
      request.fields['lid'] = lid.toString();

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (data['status'] == 'ok') {
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage = data['message'] ?? "Failed to change password";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error. Check your connection.";
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Password Changed!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your password has been updated successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog

                      // Clear fields
                      _cpasswordController.clear();
                      _npasswordController.clear();
                      _conpasswordController.clear();

                      // Show success toast
                      Fluttertoast.showToast(
                        msg: "Password changed successfully! Please login again",
                        backgroundColor: successColor,
                        textColor: Colors.white,
                        gravity: ToastGravity.TOP,
                      );

                      // Navigate to login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyLoginPage(title: ""),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Login Again",
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
      },
    );
  }

  // ================= PASSWORD STRENGTH INDICATOR =================
  Widget _buildPasswordStrengthIndicator(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    Color getColor() {
      if (strength <= 2) return Colors.red;
      if (strength <= 4) return Colors.orange;
      return Colors.green;
    }

    String getText() {
      if (strength <= 2) return "Weak";
      if (strength <= 4) return "Medium";
      return "Strong";
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 5,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(getColor()),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              getText(),
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= UI =================
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
    bool showStrength = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator ??
                    (value) => value!.isEmpty ? "This field is required" : null,
            onChanged: showStrength ? (value) => setState(() {}) : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: primaryColor),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: toggle,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: errorColor, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: errorColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          if (showStrength && controller.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPasswordStrengthIndicator(controller.text),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _goToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: const Text(
            "Change Password",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: _goToHome,
          ),
        ),
        body: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  painter: ChangePasswordBackgroundPainter(color: primaryColor),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Header Icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              primaryColor.withOpacity(0.2),
                              accentColor.withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          size: 50,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      "Security",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Hello $_userName, update your password",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _userRole == "user"
                                ? Icons.person
                                : Icons.local_shipping,
                            size: 16,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _userRole == "user" ? "User Account" : "Delivery Agent Account",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Password Form Card
                    Card(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Current Password
                            _buildPasswordField(
                              controller: _cpasswordController,
                              label: "Current Password",
                              hint: "Enter your current password",
                              icon: Icons.lock_outline,
                              obscure: _obscureCurrent,
                              toggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                            ),

                            const SizedBox(height: 8),

                            // New Password
                            _buildPasswordField(
                              controller: _npasswordController,
                              label: "New Password",
                              hint: "Enter new password",
                              icon: Icons.lock_reset,
                              obscure: _obscureNew,
                              toggle: () => setState(() => _obscureNew = !_obscureNew),
                              showStrength: true,
                            ),

                            // Password Requirements
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Password must contain:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRequirementItem(
                                    "At least 8 characters",
                                    _npasswordController.text.length >= 8,
                                  ),
                                  _buildRequirementItem(
                                    "One uppercase letter",
                                    RegExp(r'[A-Z]').hasMatch(_npasswordController.text),
                                  ),
                                  _buildRequirementItem(
                                    "One lowercase letter",
                                    RegExp(r'[a-z]').hasMatch(_npasswordController.text),
                                  ),
                                  _buildRequirementItem(
                                    "One number",
                                    RegExp(r'[0-9]').hasMatch(_npasswordController.text),
                                  ),
                                  _buildRequirementItem(
                                    "One special character",
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_npasswordController.text),
                                  ),
                                ],
                              ),
                            ),

                            // Confirm Password
                            _buildPasswordField(
                              controller: _conpasswordController,
                              label: "Confirm Password",
                              hint: "Re-enter new password",
                              icon: Icons.lock_clock,
                              obscure: _obscureConfirm,
                              toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != _npasswordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),

                            // Error Message
                            if (_errorMessage.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 18,
                                      color: errorColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: errorColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Update Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.save, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      "Update Password",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Security Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            size: 20,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "For security reasons, you'll be logged out after changing your password",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isMet ? Colors.green : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isMet ? Colors.green : Colors.grey.shade600,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for background pattern
class ChangePasswordBackgroundPainter extends CustomPainter {
  final Color color;

  ChangePasswordBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final double spacing = 40;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}