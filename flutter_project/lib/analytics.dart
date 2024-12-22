import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Row(
        children: [
          Container(
            width: 200, // Placeholder for the sidebar
            color: const Color(0xFF4A696F),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildAnalyticsCard(
                          logo: Icons.camera_alt, // Instagram
                          followersChart: Icons.trending_up,
                          interactionHeatmap: Icons.grid_on,
                          recentPostImage: 'assets/images/post1.jpg',
                          recentPostText:
                              'Here is a small tip from Anna for making the best bread: First you need to...',
                          recentInteractionType: 'like',
                          interactionCount: 120000,
                        ),
                        const SizedBox(height: 20),
                        _buildAnalyticsCard(
                          logo: Icons.linked_camera, // LinkedIn
                          followersChart: Icons.trending_flat,
                          interactionHeatmap: Icons.grid_on,
                          recentPostImage: 'assets/images/post2.jpg',
                          recentPostText:
                              'Here is a tip for professional growth: Connect with more like-minded professionals.',
                          recentInteractionType: 'dislike',
                          interactionCount: 8000,
                        ),
                        const SizedBox(height: 20),
                        _buildAnalyticsCard(
                          logo: Icons.change_history, // Twitter (X)
                          followersChart: Icons.trending_down,
                          interactionHeatmap: Icons.grid_on,
                          recentPostImage: 'assets/images/post3.jpg',
                          recentPostText:
                              'Don’t forget to join the conversation about trending topics in your industry!',
                          recentInteractionType: 'like',
                          interactionCount: 50000,
                        ),
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Analytics',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required IconData logo,
    required IconData followersChart,
    required IconData interactionHeatmap,
    required String recentPostImage,
    required String recentPostText,
    required String recentInteractionType, // 'like' or 'dislike'
    required int interactionCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE9D7A4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(logo, size: 30, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                'Followers',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(followersChart, size: 100, color: Colors.black45),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child:
                    Icon(interactionHeatmap, size: 100, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Image.asset(
                recentPostImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  recentPostText,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Icon(
                    recentInteractionType == 'like'
                        ? Icons.thumb_up
                        : Icons.thumb_down,
                    size: 30,
                    color: recentInteractionType == 'like'
                        ? Colors.green
                        : Colors.red,
                  ),
                  Text(
                    '${interactionCount ~/ 1000}K',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
