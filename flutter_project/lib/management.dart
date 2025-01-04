import 'package:flutter/material.dart';
import 'sidebar.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  String selectedRole = 'Worker'; // Default selection for dropdown menu
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(
              selectedMenu: 'Management'), // Sidebar with "Management" selected
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2), // Background color
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add User or Manager',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 500, // Set fixed width
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      items: <String>['Worker', 'Manager']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 240, 235, 235)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF4A696F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                      ),
                      dropdownColor: const Color(0xFF4A696F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 500, // Set fixed width
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 240, 235, 235)),
                        filled: true,
                        fillColor: const Color(0xFF4A696F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 500, // Set fixed width
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 240, 235, 235)),
                        filled: true,
                        fillColor: const Color(0xFF4A696F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 500, // Set fixed width
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to add user or manager
                        final role = selectedRole;
                        final email = emailController.text;
                        final password = passwordController.text;

                        // Perform logic with collected values
                        print(
                            'Role: $role, Email: $email, Password: $password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBA87C),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        selectedRole == 'Worker' ? 'Add Worker' : 'Add Manager',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
}
