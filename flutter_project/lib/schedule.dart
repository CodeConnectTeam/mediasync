import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/weekly_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'sidebar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

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
                            filterValues: ['DRAFT', 'SCHEDULED'],
                            textKey: 'tweetText',
                          ),
                          _buildPostList(
                            context,
                            token,
                            apiEndpoint:
                                'http://13.60.226.247:8080/api/posts/instagram',
                            filterKey: 'status',
                            filterValues: ['SCHEDULED'],
                            textKey: 'caption',
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
              return _buildPostItem(post, textKey);
            },
          );
        }
      },
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, String textKey) {
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
                    'Created at: ${_formatCreatedAt(post['createdAt'])}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Tarih seçme işlemi
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
                      // Onaylama işlemi
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
                      // Reddetme işlemi
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

        // Belirli durumlara göre filtreleme
        return data
            .where((e) => filterValues.contains(e[filterKey]))
            .map((e) => {
                  'id': e['id'],
                  textKey: e[textKey],
                  'createdAt': e['createdAt'],
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
}
