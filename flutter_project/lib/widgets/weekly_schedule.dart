import 'package:flutter/material.dart';

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
