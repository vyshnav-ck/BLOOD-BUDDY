import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditProfileScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController phoneController;

  String? selectedBloodGroup;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.data['name']);
    locationController =
        TextEditingController(text: widget.data['location']);
    phoneController =
        TextEditingController(text: widget.data['phone']);

    selectedBloodGroup = widget.data['bloodGroup'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              decoration:
                  const InputDecoration(labelText: "Blood Group"),
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

            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration:
                  const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration:
                  const InputDecoration(labelText: "Phone"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('donors')
                      .doc(widget.docId)
                      .update({
                    'name': nameController.text.trim(),
                    'bloodGroup': selectedBloodGroup,
                    'location': locationController.text.trim(),
                    'phone': phoneController.text.trim(),
                  });

                  Navigator.pop(context);
                },
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
