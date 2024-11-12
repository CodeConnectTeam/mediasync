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
              color: const Color(0xFFF4EEE2),
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: Text(
                  'This is the Create Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
