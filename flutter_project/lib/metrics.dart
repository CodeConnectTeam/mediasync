import 'package:flutter/material.dart';
import 'sidebar.dart'; // Import your sidebar widget here
import 'package:fl_chart/fl_chart.dart'; // Assuming you're using fl_chart for the graphs

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Section (from CreatePage)
          const SideBar(
            selectedMenu: 'Metrics', // Sidebar with "Metrics" selected
          ),
          // Main content section
          Expanded(
            child: SingleChildScrollView(
              // Content is now scrollable
              child: Container(
                color: const Color(0xFFF4EEE2), // Right area background color
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metrics Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Instagram Metrics Section
                    const Text(
                      'Instagram Metrics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        metricCard(Icons.favorite, 'Likes', 1024),
                        metricCard(Icons.comment, 'Comments', 320),
                        metricCard(Icons.share, 'Shares', 150),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Engagement Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    engagementGraph(),
                    const SizedBox(height: 40),

                    // Twitter Metrics Section
                    const Text(
                      'Twitter Metrics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        metricCard(Icons.message, 'Replies', 500),
                        metricCard(Icons.favorite_border, 'Likes', 1200),
                        metricCard(Icons.repeat, 'Retweets', 450),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Engagement Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    engagementGraph(),
                    const SizedBox(height: 30), // Adjusted the bottom spacing
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
      width: 100,
      padding: const EdgeInsets.all(12.0),
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
          Icon(icon, size: 40, color: const Color(0xFF4A696F)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Engagement graph widget using fl_chart
  Widget engagementGraph() {
    return SizedBox(
      height: 180, // Adjusted height for better fitting
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 5),
                FlSpot(4, 4),
                FlSpot(5, 6),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: const Color.fromARGB(255, 95, 143, 182),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
          ],
          titlesData: FlTitlesData(show: false), // Hide axis titles
          gridData: FlGridData(show: false), // Hide grid lines
          borderData: FlBorderData(show: false), // Hide border lines
        ),
      ),
    );
  }
}
