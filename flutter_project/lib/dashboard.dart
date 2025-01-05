import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; // Import provider
import 'sidebar.dart'; // Assuming SideBar widget is available
import 'authprovider.dart'; // Assuming AuthProvider is your auth provider class

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();

  // Fetch Instagram Metrics with token
  Future<List<Map<String, dynamic>>> fetchInstagramMetrics(String token) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/posts/instagram/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add Authorization header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(json.decode(response.body));
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load Instagram posts');
      }
    } catch (e) {
      throw Exception('Failed to fetch Instagram posts: $e');
    }
  }

  // Fetch Twitter Metrics with token
  Future<List<Map<String, dynamic>>> fetchTwitterMetrics(String token) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/posts/twitter');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add Authorization header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(json.decode(response.body));
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load Twitter posts');
      }
    } catch (e) {
      throw Exception('Failed to fetch Twitter posts: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve token from the AuthProvider
    final String? token = Provider.of<AuthProvider>(context).token;

    // Check if token is null, if so redirect to login
    if (token == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedMenu: 'Dashboard'),
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2),
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Instagram section
                  _buildInstagramSection(token),
                  const SizedBox(height: 40),
                  // Twitter section
                  _buildTwitterSection(token),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Instagram section widget
  Widget _buildInstagramSection(String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Instagram Posts",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200, // Instagram section height
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchInstagramMetrics(token), // Fetch Instagram data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No Instagram posts available.'));
              } else {
                // Filter posts where status is "PUBLISHED"
                final metrics = snapshot.data!
                    .where((post) => post['status'] == 'PUBLISHED')
                    .toList();
                return ListView.builder(
                  controller: _scrollController, // ScrollController
                  scrollDirection: Axis.horizontal, // Horizontal scroll
                  itemCount: metrics.length, // Based on data count
                  itemBuilder: (context, index) =>
                      _buildInstagramPost(metrics[index]),
                );
              }
            },
          ),
        ),
      ],
    );
  }

// Twitter section widget
  Widget _buildTwitterSection(String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Twitter Posts",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 400, // Twitter section height
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchTwitterMetrics(token), // Fetch Twitter data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Twitter posts available.'));
              } else {
                // Filter posts where status is "PUBLISHED"
                final metrics = snapshot.data!
                    .where((post) => post['status'] == 'PUBLISHED')
                    .toList();
                return ListView.builder(
                  controller: _scrollController, // ScrollController
                  itemCount: metrics.length, // Based on data count
                  itemBuilder: (context, index) =>
                      _buildTwitterPost(metrics[index]),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Build Instagram post widget
  Widget _buildInstagramPost(Map<String, dynamic> post) {
    return Container(
      width: 150, // Width of each Instagram post
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Instagram post image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              post['imageUrl'] ?? 'https://picsum.photos/200', // Post image URL
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          // Username (default to "mediasyncteam" if not available)
          Text(
            post['username'] ?? '@mediasyncteam', // Display username or default
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Build Twitter post widget
  Widget _buildTwitterPost(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['username'] ?? '@mediasync252408', // Display username
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  post['tweetText'] ?? 'No content', // Display tweet content
                  overflow:
                      TextOverflow.ellipsis, // Ensure it fits within screen
                  maxLines: 3, // Limit lines to prevent overflow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
