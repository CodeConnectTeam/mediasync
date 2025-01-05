import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/weekly_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'sidebar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    if (token == null) {
      return const LoginPage();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Row(
          children: [
            const SideBar(selectedMenu: 'Schedule'),
            Expanded(
              child: Container(
                color: const Color(0xFFF4EEE2),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: 'Twitter'),
                        Tab(text: 'Instagram'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPostList(
                            context,
                            token,
                            apiEndpoint:
                                'http://13.60.226.247:8080/api/posts/twitter',
                            filterKey: 'status',
                            filterValues: ['SCHEDULED'],
                            textKey: 'tweetText',
                            platform: 'TWITTER',
                          ),
                          _buildPostList(
                            context,
                            token,
                            apiEndpoint:
                                'http://13.60.226.247:8080/api/posts/instagram',
                            filterKey: 'status',
                            filterValues: ['SCHEDULED'],
                            textKey: 'caption',
                            platform: 'INSTAGRAM',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(
    BuildContext context,
    String token, {
    required String apiEndpoint,
    required String filterKey,
    required List<String> filterValues,
    required String textKey,
    required String platform,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFilteredPosts(
        token,
        apiEndpoint,
        filterKey: filterKey,
        filterValues: filterValues,
        textKey: textKey,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load posts. Error: ${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No posts available.',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostItem(post, textKey, token, platform);
            },
          );
        }
      },
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, String textKey, String token,
      String platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${textKey == "tweetText" ? "Tweet" : "Caption"}: ${post[textKey] ?? 'No content'}\n'
                    'Created at: ${_formatCreatedAt(post['createdAt'])}\n',
                    //  'Scheduled at: ${_formatScheduledTime(post['scheduledTime'])}', // Show scheduled time
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await _selectDate(context);
                      if (newDate != null) {
                        setState(() {
                          selectedDateTime = newDate;
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deletePost(context, token, post['id'], platform);
                    },
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

  String _formatScheduledTime(dynamic scheduledTime) {
    if (scheduledTime != null) {
      try {
        final date = DateTime.parse(scheduledTime).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        return '';
      }
    }
    return '';
  }

  String _formatCreatedAt(dynamic createdAt) {
    if (createdAt is List) {
      try {
        final date = DateTime(
          createdAt[0],
          createdAt[1],
          createdAt[2],
          createdAt[3],
          createdAt[4],
          createdAt[5],
        ).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        return 'Invalid date format';
      }
    }
    return 'No date available';
  }

  Future<List<Map<String, dynamic>>> fetchFilteredPosts(
    String token,
    String apiEndpoint, {
    required String filterKey,
    required List<String> filterValues,
    required String textKey,
  }) async {
    final url = Uri.parse(apiEndpoint);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filter posts by status
        return data
            .where((e) => filterValues.contains(e[filterKey]))
            .map((e) => {
                  'id': e['id'],
                  textKey: e[textKey],
                  'createdAt': e['createdAt'],
                  'scheduledTime': e['scheduledTime'], // Fetch scheduledTime
                })
            .toList();
      } else {
        throw Exception(
          'Failed to load posts. Server responded with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  Future<void> _deletePost(
    BuildContext context,
    String token,
    int postId,
    String platform,
  ) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/schedule')
        .replace(queryParameters: {
      'post_id': postId.toString(),
      'platform': platform,
    });

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Scheduled post was deleted successfully!')),
        );

        // Manually trigger the UI update by calling setState
        setState(() {
          // Refresh the post list
        });
      } else {
        throw Exception(
            'Failed to delete post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );

      if (timePicked != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
      }
    }
    return null;
  }

  Future<void> _updateScheduledPost(
    String token,
    int postId,
    String platform,
  ) async {
    if (selectedDateTime == null) {
      return;
    }

    final url = Uri.parse('http://13.60.226.247:8080/api/schedule/');
    final body = jsonEncode({
      'scheduled_time': selectedDateTime?.toIso8601String(),
      'platform': platform,
      'is_active': true,
      'post_id': '$postId'
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully!')),
        );
      } else {
        throw Exception(
            'Failed to update post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
