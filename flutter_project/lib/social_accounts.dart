import 'package:flutter/material.dart';
import 'package:flutter_project/sidebar.dart';

class SocialAccountsPage extends StatelessWidget {
  const SocialAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Row(
        children: [
          const SideBar(selectedMenu: "Social Accounts"), // Sidebar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(), // Header
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSocialAccountList(), // Social accounts list
                        const Spacer(),
                        _buildAddAccountButton(), // Add account button
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
    // Header with page title
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'Social Accounts',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildSocialAccountList() {
    // List of social accounts
    final accounts = [
      {'icon': Icons.camera_alt, 'label': '@kitten_patisserie'},
      {'icon': Icons.camera_alt_outlined, 'label': '@kitten_patisserie_tr'},
      {'icon': Icons.facebook, 'label': '@kitten_patisserie_turkey'},
      {'icon': Icons.work, 'label': '@kitten_bakery'},
    ];

    return Column(
      children: accounts
          .map(
            (account) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3C5A4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(account['icon'] as IconData, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        account['label'] as String,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle delete action
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAddAccountButton() {
    // Add account button
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          // Handle add account action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A696F),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Add account',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
