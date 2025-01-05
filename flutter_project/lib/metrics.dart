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

  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    if (token == null) {
      return const LoginPage(); // Token yoksa giriş sayfasına yönlendir
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Section
          const SideBar(
            selectedMenu: 'Metrics', // Sidebar'da "Metrics" seçili
          ),
          // Ana içerik kısmı
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2), // Sağ alanın arka plan rengi
              padding: const EdgeInsets.all(10.0), // Padding azaltıldı
              child: Scrollbar(
                controller: _scrollController, // Attach the controller
                thumbVisibility: true, // Make the scrollbar visible
                child: ListView(
                  controller: _scrollController, // Attach the controller
                  children: [
                    const Text(
                      'Metrics Dashboard',
                      style: TextStyle(
                        fontSize: 24, // Font büyüklüğü azaltıldı
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16), // Yükseklik azaltıldı
                    const Text(
                      'Instagram Metrics',
                      style: TextStyle(
                        fontSize: 22, // Font büyüklüğü azaltıldı
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), // Yükseklik azaltıldı
                    // Instagram Metrics verilerini al ve göster
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchInstagramMetrics(token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No metrics available');
                        } else {
                          final metrics = snapshot.data!;
                          return Column(
                            children: metrics.map((metric) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12.0), // Daha az boşluk ekleniyor
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly, // Boşluk daha eşit olacak
                                        children: [
                                          metricCard(Icons.favorite, 'Likes',
                                              metric['like_count']),
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
                                      const SizedBox(height: 8),
                                      Text(
                                        'Caption: ${metric['caption']}',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Link: ${metric['permalink']}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Metric card widget
  Widget metricCard(IconData icon, String label, int value) {
    return Container(
      width: 80, // Genişlik küçültüldü
      padding: const EdgeInsets.all(8.0), // Padding küçültüldü
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
        mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortalama
        children: [
          Icon(icon,
              size: 30,
              color: const Color(0xFF4A696F)), // İkon boyutu küçültüldü
          const SizedBox(height: 4), // Yükseklik azaltıldı
          Text(
            label,
            style: const TextStyle(
              fontSize: 10, // Font küçültüldü
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2), // Yükseklik azaltıldı
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16, // Font küçültüldü
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
