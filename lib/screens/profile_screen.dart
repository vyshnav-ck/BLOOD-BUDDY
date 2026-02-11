import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('donors')
      .where('userId',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .limit(1)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text("You are not registered as a donor."),
      );
    }

    final doc = snapshot.data!.docs.first;
final data = doc.data();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFE53935),
            child: Icon(Icons.person,
                size: 50, color: Colors.white),
          ),

          const SizedBox(height: 20),

          Text(
            FirebaseAuth.instance.currentUser?.email ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          _profileTile("Name", data['name']),
          _profileTile("Blood Group", data['bloodGroup']),
          _profileTile("Location", data['location']),
          _profileTile("Phone", data['phone']),

          const Spacer(),

SizedBox(
  width: double.infinity,
  height: 50,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFFE53935), 
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            docId: doc.id,
            data: data,
          ),
        ),
      );
    },
    child: const Text("Edit Profile"),
  ),
),

const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  },
),
    );
  }

  Widget _profileTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
