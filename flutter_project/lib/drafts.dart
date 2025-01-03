import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'sidebar.dart';

class DraftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    if (token == null) {
      return const LoginPage(); // Token yoksa giriş sayfasına yönlendir
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Row(
        children: [
          SideBar(selectedMenu: "Drafts"),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchDrafts(token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load drafts.\nError: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No drafts available.',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        } else {
                          var drafts = snapshot.data!;
                          return ListView.builder(
                            itemCount: drafts.length,
                            itemBuilder: (context, index) {
                              var draft = drafts[index];
                              return ListTile(
                                title: Text(
                                  draft['tweetText'] ?? 'No text available',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Created At: ${_formatDate(draft['createdAt'])}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Delete functionality (eklenebilir)
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'Drafts',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    try {
      if (createdAt is String) {
        final date = DateTime.parse(createdAt).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } else if (createdAt is List) {
        DateTime date = DateTime(
          createdAt[0],
          createdAt[1],
          createdAt[2],
          createdAt[3],
          createdAt[4],
          createdAt[5],
        );
        return date.toLocal().toString();
      } else {
        return 'Invalid date format';
      }
    } catch (e) {
      return 'Error formatting date: $e';
    }
  }

  Future<List<Map<String, dynamic>>> fetchDrafts(String token) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/posts/twitter/drafts');

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
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Failed to load drafts. Server responded with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching drafts: $e');
    }
  }
}
