// login.dart
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EEE2), // Set background color for the whole page
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MediaSync title
              const Text(
                'MediaSync',
                style: TextStyle(
                  fontFamily: 'KingredModern',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Login title with updated font and size
              const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'DMSans', // Set font to DM Sans
                  fontSize: 13,          // Set font size to 13
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Email text field
              SizedBox(
                width: 300, // Limit width
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16.5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              // Password text field
              SizedBox(
                width: 300, // Limit width
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16.5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              // Register text with new color
              GestureDetector(
                onTap: () {
                  // Add Register logic here
                },
                child: const Text(
                  'Don’t have any account? Register',
                  style: TextStyle(
                    color: Color(0xFF474740), // Set text color to #474740
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Login button
              SizedBox(
                width: 300, // Limit width
                child: ElevatedButton(
                  onPressed: () {
                    // Add Login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBA87C), // Set background color to #BBA87C
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Set text color to #FFFFFF
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
