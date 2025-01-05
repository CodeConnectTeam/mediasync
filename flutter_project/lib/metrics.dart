import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert'; // For JSON decoding
import 'sidebar.dart';
import 'login.dart';
import 'authprovider.dart'; // Assuming this is the provider for Auth

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  _MetricsPageState createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  // ScrollController to manage scroll and connect to the Scrollbar
  final ScrollController _scrollController = ScrollController();

  Future<List<Map<String, dynamic>>> fetchInstagramMetrics(String token) async {
    final url =
        Uri.parse('http://13.60.226.247:8080/api/posts/INSTAGRAM/metrics');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(json.decode(response.body));
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load metrics');
      }
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTwitterMetrics(String token) async {
    final url =
        Uri.parse('http://13.60.226.247:8080/api/posts/TWITTER/metrics');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(json.decode(response.body));
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load Twitter metrics');
      }
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    if (token == null) {
      return const LoginPage(); // Redirect to login page if token is null
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Section
          const SideBar(
            selectedMenu: 'Metrics', // "Metrics" selected in the sidebar
          ),
          // Main content section
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2), // Background color
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metrics Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Color(0xFFBBA87C),
                            tabs: [
                              Tab(text: 'Instagram'),
                              Tab(text: 'Twitter')
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Instagram Tab
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: fetchInstagramMetrics(token),
                                  builder: (context, snapshot) {
                                    return buildMetricsView(snapshot, true);
                                  },
                                ),
                                // Twitter Tab
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: fetchTwitterMetrics(token),
                                  builder: (context, snapshot) {
                                    return buildMetricsView(snapshot, false);
                                  },
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
          ),
        ],
      ),
    );
  }

  Widget buildMetricsView(
    AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
    bool isInstagram,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No metrics available'));
    } else {
      final metrics = snapshot.data!;
      return ListView.builder(
        controller: _scrollController,
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EEE2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (isInstagram) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        metricCard(
                            Icons.favorite, 'Likes', metric['like_count']),
                        metricCard(Icons.comment, 'Comments',
                            metric['comments_count']),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      metric['media_url'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        metricCard(Icons.visibility, 'Impressions',
                            metric['public_metrics']['impression_count']),
                        metricCard(Icons.comment, 'Replies',
                            metric['public_metrics']['reply_count']),
                        metricCard(Icons.favorite, 'Likes',
                            metric['public_metrics']['like_count']),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    isInstagram
                        ? 'Caption: ${metric['caption']}'
                        : 'Tweet: ${metric['text']}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Metric card widget
  Widget metricCard(IconData icon, String label, int value) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEE2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: const Color(0xFF4A696F)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.black)),
          const SizedBox(height: 2),
          Text('$value',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
