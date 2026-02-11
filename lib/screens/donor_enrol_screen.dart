import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/donor_provider.dart';

class DonorEnrolScreen extends StatefulWidget {
  const DonorEnrolScreen({super.key});

  @override
  State<DonorEnrolScreen> createState() => _DonorEnrolScreenState();
}

class _DonorEnrolScreenState extends State<DonorEnrolScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final emergencyController = TextEditingController();

  String? selectedBloodGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Register as Donor"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              // Name
              TextField(
                controller: nameController,
                decoration: _inputDecoration("Full Name"),
              ),

              const SizedBox(height: 16),

              // Phone
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Phone Number"),
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

              const SizedBox(height: 16),

              // Emergency Contact
              TextField(
                controller: emergencyController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Emergency Contact"),
              ),

              const SizedBox(height: 30),

              // Register Button
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
                      await Provider.of<DonorProvider>(
                        context,
                        listen: false,
                      ).addDonor(
                        name: nameController.text.trim(),
                        bloodGroup: selectedBloodGroup ?? "Unknown",
                        location: locationController.text.trim(),
                        phone: phoneController.text.trim(),
                        emergencyContact: emergencyController.text.trim(),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: const Text(
                    "Register as Donor",
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
