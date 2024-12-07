// schedule.dart
import 'package:flutter/material.dart';
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
                  Expanded(child: WeeklySchedule()),
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

class WeeklySchedule extends StatelessWidget {
  const WeeklySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4A696F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDayHeader(index),
                        const SizedBox(height: 10),
                        ..._mockTasks(
                            index), // Generate mock tasks for each day
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD3C5A4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      alignment: Alignment.center,
      child: Text(
        days[index],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  List<Widget> _mockTasks(int dayIndex) {
    // Mock task data for each day
    final tasks = [
      [],
      ['LinkedIn: How to make puffy bread...'],
      [
        'Instagram + X + LinkedIn: Announcing our new facil...',
        'Instagram: Have you tasted our...'
      ],
      [],
      ['Instagram + X + LinkedIn: Stop the genocide right NOW! #free'],
      [],
      [],
    ];

    // Generate task widgets for the given day
    return tasks[dayIndex].map((task) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            _buildSocialIcons(task), // Social icons extracted from task text
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.split(': ').last, // Extract task content
                style: const TextStyle(fontSize: 14, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSocialIcons(String task) {
    // Define mock icons based on keywords in the task
    final icons = {
      'Instagram': Icons.camera_alt,
      'LinkedIn': Icons.work_outline,
      'X': Icons.chat_bubble_outline,
    };

    final iconWidgets = icons.keys
        .where((platform) => task.contains(platform))
        .map((platform) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                icons[platform],
                size: 16,
                color: _getPlatformColor(platform),
              ),
            ))
        .toList();

    return Row(children: iconWidgets);
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'Instagram':
        return Colors.pink;
      case 'LinkedIn':
        return Colors.blue;
      case 'X':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}
