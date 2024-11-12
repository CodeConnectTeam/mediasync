// profile.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedMenu: 'Profile'), // Sidebar with "Profile" selected
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Profile Fields with horizontal layout
                  _buildProfileField('Name', 'John Doe'),
                  const SizedBox(height: 20),
                  _buildProfileField('Role', 'User'),
                  const SizedBox(height: 20),
                  _buildProfileField('Email', 'johndoe@gmail.com'),
                  const SizedBox(height: 20),
                  _buildProfileField('Password', '********'),
                  const SizedBox(height: 30),
                  // Save Profile Button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add save profile functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBA87C), // Button background color
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for profile fields (name and value side by side)
  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Label text (name, role, email, etc.)
          SizedBox(
            width: 100, // Set width for labels to ensure alignment
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20), // Space between label and value
          // Value text (John Doe, johndoe@gmail.com, etc.)
          Container(
            padding: const EdgeInsets.all(12.0),
            width: 200, // Set width for value containers to ensure alignment
            decoration: BoxDecoration(
              color: const Color(0xFF4A696F), // Background color for field
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
