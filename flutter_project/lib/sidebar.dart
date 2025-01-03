import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String selectedMenu;

  const SideBar({super.key, required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
      {'label': 'Drafts', 'icon': Icons.menu, 'route': '/drafts'},
      {'label': 'Schedule', 'icon': Icons.schedule, 'route': '/schedule'},
      {'label': 'Create', 'icon': Icons.create, 'route': '/create'},
      {'label': 'Analytics', 'icon': Icons.analytics, 'route': '/analytics'},
      {'label': 'Profile', 'icon': Icons.person, 'route': '/profile'},
      {
        'label': 'Management',
        'icon': Icons.manage_accounts,
        'route': '/management'
      },
      {'label': 'Logout', 'icon': Icons.logout, 'route': '/logout'},
    ];

    return Container(
      color: const Color(0xFF4A696F),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'MediaSync',
              style: TextStyle(
                fontFamily: 'KingredModern',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (var item in menuItems)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: TextButton.icon(
                icon: Icon(
                  item['icon'],
                  color: item['label'] == 'Logout'
                      ? const Color(0xFFFF6666)
                      : Colors.white,
                  size: 20,
                ),
                label: Text(
                  item['label'],
                  style: TextStyle(
                    color: item['label'] == 'Logout'
                        ? const Color(0xFFFF6666)
                        : Colors.white,
                    fontSize: 16,
                    fontFamily: 'DMSans',
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: selectedMenu == item['label']
                      ? const Color(0xFF647D87) // Highlight selected item
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size.fromHeight(50),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                onPressed: () {
                  if (item['label'] == 'Logout') {
                    // Add logout functionality here
                    Navigator.pushNamed(context, '/login');
                  } else if (item['label'] == selectedMenu) {
                    // Do not navigate to the same page
                  } else {
                    Navigator.pushNamed(context, item['route']);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
