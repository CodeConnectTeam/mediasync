import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4EEE2), // Set background color for the whole page
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
              // Register title with updated font and size
              const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'DMSans', // Set font to DM Sans
                  fontSize: 13, // Set font size to 13
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Name text field
              SizedBox(
                width: 300, // Limit width
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16.5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
              // Login text with new color
              GestureDetector(
                onTap: () {
                  // Add Login logic here
                },
                child: GestureDetector(
                  onTap: () {
                    // Navigate to LoginPage
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: const Text(
                    'Do you have any account? Login',
                    style: TextStyle(
                      color: Color(0xFF474740), // Set text color to #474740
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Register button
              SizedBox(
                width: 300, // Limit width
                child: ElevatedButton(
                  onPressed: () {
                    // Add Register logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFFBBA87C), // Set background color to #BBA87C
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Register',
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
