// schedule.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/weekly_schedule.dart';
import 'sidebar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(
              selectedMenu: 'Schedule'), // Sidebar with "Schedule" selected
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Drafts section
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4, // Number of drafts to display
                      itemBuilder: (context, index) {
                        return _buildDraftItem();
                      },
                    ),
                  ),

                  // Calendar
                  const SizedBox(height: 20),
                  const Expanded(child: WeeklySchedule()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a single draft item
  Widget _buildDraftItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon representing the social media platform
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Your caption preview will appear here',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              // Action buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Decline'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
