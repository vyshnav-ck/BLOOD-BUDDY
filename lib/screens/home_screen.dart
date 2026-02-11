import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/donor_provider.dart';
import 'donor_enrol_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  String selectedBloodGroup = "All";
TextEditingController locationController = TextEditingController();

String appliedBloodGroup = "All";
String appliedLocation = "";

  // ---------------- HOME CONTENT ----------------
  Widget _homeContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Blood Buddy 🩸",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Filter Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
  value: selectedBloodGroup,
  decoration: const InputDecoration(
    labelText: "Blood Group",
    border: InputBorder.none,
  ),
  items: const [
    DropdownMenuItem(value: "All", child: Text("All")),
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
      selectedBloodGroup = value!;
    });
  },
),

const Divider(),

TextField(
  controller: locationController,
  decoration: const InputDecoration(
    hintText: "Location",
    border: InputBorder.none,
    icon: Icon(Icons.location_on_outlined),
  ),
),

const SizedBox(height: 10),

// Search button
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE53935),
    ),
    onPressed: () {
      setState(() {
        appliedBloodGroup = selectedBloodGroup;
        appliedLocation = locationController.text.trim().toLowerCase();
      });
    },
    icon: const Icon(Icons.search),
    label: const Text("Search"),
  ),
),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Donor List
            Expanded(
  child: Consumer<DonorProvider>(
    builder: (context, provider, child) {
      final filteredDonors = provider.donors.where((donor) {
        final matchesBlood = appliedBloodGroup == "All" ||
            donor.bloodGroup == appliedBloodGroup;

        final matchesLocation = appliedLocation.isEmpty ||
            donor.location
                .toLowerCase()
                .contains(appliedLocation);

        return matchesBlood && matchesLocation;
      }).toList();

      if (filteredDonors.isEmpty) {
        return const Center(
          child: Text(
            "No donors found",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: filteredDonors.length,
        itemBuilder: (context, index) {
          final donor = filteredDonors[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      donor.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        donor.bloodGroup,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  donor.location,
                  style:
                      const TextStyle(color: Colors.grey),
                ),

                            const SizedBox(height: 12),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final uri =
                                          Uri.parse("tel:${donor.phone}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    icon: const Icon(Icons.call),
                                    label: const Text("Call"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFE53935),
                                    ),
                                    onPressed: () async {
                                      final uri = Uri.parse(
                                          "tel:${donor.emergencyContact}");
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    },
                                    icon: const Icon(Icons.warning),
                                    label: const Text("Emergency"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      body: currentIndex == 0
          ? _homeContent()
          : const ProfileScreen(),

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFFE53935),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DonorEnrolScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Register Donor"),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFFE53935),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
