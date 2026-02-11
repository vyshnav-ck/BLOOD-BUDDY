import 'package:flutter/material.dart';

class SearchDonorScreen extends StatefulWidget {
  const SearchDonorScreen({super.key});

  @override
  State<SearchDonorScreen> createState() => _SearchDonorScreenState();
}

class _SearchDonorScreenState extends State<SearchDonorScreen> {
  String? _bloodGroup;
  String _location = '';

  final List<String> bloodGroups = [
    'A+','A-','B+','B-','AB+','AB-','O+','O-'
  ];

  // 🔥 TEMP mock donors (later from Firestore)
  final List<Map<String, String>> donors = [
    {
      'name': 'Arjun',
      'blood': 'O+',
      'location': 'Kozhikode',
      'phone': '9876543210',
    },
    {
      'name': 'Rahul',
      'blood': 'A+',
      'location': 'Kochi',
      'phone': '9123456789',
    },
    {
      'name': 'Sneha',
      'blood': 'B+',
      'location': 'Kozhikode',
      'phone': '9988776655',
    },
  ];

  List<Map<String, String>> get filteredDonors {
    return donors.where((d) {
      final matchBlood =
          _bloodGroup == null || d['blood'] == _bloodGroup;
      final matchLocation =
          _location.isEmpty ||
          d['location']!
              .toLowerCase()
              .contains(_location.toLowerCase());

      return matchBlood && matchLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Blood Donor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _bloodGroup,
              items: bloodGroups
                  .map(
                    (bg) => DropdownMenuItem(
                      value: bg,
                      child: Text(bg),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _bloodGroup = v),
              decoration:
                  const InputDecoration(labelText: 'Blood Group'),
            ),

            const SizedBox(height: 12),

            TextField(
              decoration:
                  const InputDecoration(labelText: 'Location'),
              onChanged: (v) => setState(() => _location = v),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredDonors.isEmpty
                  ? const Center(
                      child: Text('No donors found'),
                    )
                  : ListView.builder(
                      itemCount: filteredDonors.length,
                      itemBuilder: (context, i) {
                        final d = filteredDonors[i];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(
                                d['blood']!,
                                style:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(d['name']!),
                            subtitle: Text(d['location']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.call),
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Call ${d['phone']}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
