import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/donor_provider.dart';



class RegisterDonorScreen extends StatefulWidget {
  const RegisterDonorScreen({super.key});

  @override
  State<RegisterDonorScreen> createState() => _RegisterDonorScreenState();
}

class _RegisterDonorScreenState extends State<RegisterDonorScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();

  String? selectedBloodGroup;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Register as Donor",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Help save lives by becoming a donor",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // Name
              TextField(
  controller: nameController,
  decoration: _inputDecoration("Full Name"),
),

              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                decoration: _inputDecoration("Email"),
              ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration("Password"),
              ),

              const SizedBox(height: 16),

              // Blood Group
              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Blood Group"),
                items: const [
                  DropdownMenuItem(value: "A+", child: Text("A+")),
                  DropdownMenuItem(value: "A-", child: Text("A-")),
                  DropdownMenuItem(value: "B+", child: Text("B+")),
                  DropdownMenuItem(value: "B-", child: Text("B-")),
                  DropdownMenuItem(value: "O+", child: Text("O+")),
                  DropdownMenuItem(value: "O-", child: Text("O-")),
                  DropdownMenuItem(value: "AB+", child: Text("AB+")),
                  DropdownMenuItem(value: "AB-", child: Text("AB-")),
                ],
                onChanged: (value) {
  setState(() {
    selectedBloodGroup = value;
  });
},
              ),

              const SizedBox(height: 16),

              // Location
              TextField(
                controller: locationController,
                decoration: _inputDecoration("Location"),
              ),

              const SizedBox(height: 30),

              // Register button
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  } catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
  },
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}



