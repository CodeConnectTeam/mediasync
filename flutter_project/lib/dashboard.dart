import 'package:flutter/material.dart';
import 'package:flutter_project/sidebar.dart';
import 'package:flutter_project/widgets/weekly_schedule.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Row(
        children: [
          const SideBar(selectedMenu: "Dashboard"), // Sidebar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(), // Header section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsRow(), // Stats row
                        const SizedBox(height: 20),
                        const Expanded(
                          child: WeeklySchedule(),
                        ),
                        const SizedBox(height: 20),
                        _buildApprovalSection(), // Waiting for approval section
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Header with Dashboard title
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    // Row with stats (Followers, Likes, Events)
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.person,
            'Followers',
            '34,6%',
            color: Colors.green.shade300,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            Icons.thumb_down,
            'Likes',
            '3,7%',
            color: Colors.red.shade300,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            Icons.event,
            'Incoming Special Events\n 3 December',
            'World Disability Day',
            color: Colors.blue,
            isEvent: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value,
      {Color color = Colors.black, bool isEvent = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A696F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xAAF5F0E8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: isEvent ? const Color(0xFFF5F0E8) : color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalSection() {
    // Waiting for Approval section
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF4A696F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Text(
              'JP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jake Peralta',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xAAF5F0E8)),
                ),
                SizedBox(height: 5),
                Text(
                  'Hey John, I changed color palette as you demanded. Please stop sending this...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Color(0xFFF5F0E8)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/seed/picsum/400/250', // Mock image
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
