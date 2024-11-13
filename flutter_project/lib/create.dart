// create.dart
import 'package:flutter/material.dart';
import 'sidebar.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedMenu: 'Create'), // Sidebar with "Create" selected
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2), // Right area background color
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Draft Post Input Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Drafting area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Caption',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Caption Input
                            TextField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Write your caption...',
                                hintStyle: const TextStyle(
                                  color: Colors.white, // Set hint text color to white
                                ),
                                filled: true,
                                fillColor: const Color(0xFF4A696F), // Caption box color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(12.0),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            // Add Location Button
                            ElevatedButton.icon(
                              onPressed: () {
                                // Logic to add location
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBBA87C), // Button color
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.location_on, color: Colors.white),
                              label: const Padding(
                                padding: EdgeInsets.only(right: 10.0), // Add right padding
                                child: Text(
                                  'Add Location',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Tag People Button
                            ElevatedButton.icon(
                              onPressed: () {
                                // Logic to tag people
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBBA87C), // Button color
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.person_add, color: Colors.white),
                              label: const Padding(
                                padding: EdgeInsets.only(right: 10.0), // Add right padding
                                child: Text(
                                  'Tag People',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Right side: Preview area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Post Preview Box
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image, size: 100, color: Colors.grey),
                                  const SizedBox(height: 10),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Your image preview will appear here.',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Text(
                                      'Your caption preview will appear here.',
                                      style: TextStyle(color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Save as Draft Button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to save draft
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBA87C),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save as Draft',
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
}
