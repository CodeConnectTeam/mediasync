import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/weekly_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'sidebar.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    if (token == null) {
      return const LoginPage(); // Token yoksa giriş sayfasına yönlendir
    }

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

                  // Schedule section
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchSchedules(
                          token), // Pass the token to fetchSchedules
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load schedules. Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No schedules available.',
                                style: TextStyle(fontSize: 18)),
                          );
                        } else {
                          var schedules = snapshot.data!;
                          return ListView.builder(
                            itemCount: schedules.length,
                            itemBuilder: (context, index) {
                              var schedule = schedules[index];
                              return _buildScheduleItem(schedule);
                            },
                          );
                        }
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

  // Helper method to build a single schedule item
  Widget _buildScheduleItem(Map<String, dynamic> schedule) {
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
                  Text(
                    'Scheduled to ${schedule['platform']} at ${_formatDate(schedule['scheduled_time'])}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),

              // Action buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Select Date action
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // Accept action
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // Decline action
                    },
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

  // Helper method to format date
  String _formatDate(dynamic scheduledTime) {
    try {
      if (scheduledTime is String) {
        final date = DateTime.parse(scheduledTime).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return 'Invalid date format';
      }
    } catch (e) {
      return 'Error formatting date: $e';
    }
  }

  // Fetch schedules from the API
  Future<List<Map<String, dynamic>>> fetchSchedules(String token) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/schedule');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer $token', // Use the token provided from the provider
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => {
                  'post_id': e['post_id'],
                  'scheduled_time': e['scheduled_time'],
                  'platform': e['platform'],
                  'is_active': e['is_active'],
                })
            .toList();
      } else {
        throw Exception(
          'Failed to load schedules. Server responded with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching schedules: $e');
    }
  }
}
