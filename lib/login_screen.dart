import 'dart:convert'; // For JSON conversion
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API requests
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For secure storage

class LoginScreen extends StatelessWidget {
  // Controllers to capture user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create an instance of FlutterSecureStorage
  final storage = FlutterSecureStorage();

  // Function to handle login
  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('https://reqres.in/api/login');

    try {
      // Send the POST request to the API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Check if the login was successful
      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Store the token securely
        await storage.write(key: 'auth_token', value: token);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful! Token saved.')),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Check your credentials.')),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Input Field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            // Password Input Field
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hides the password
            ),
            SizedBox(height: 20),
            // ElevatedButton for Login
            ElevatedButton(
              onPressed: () {
                // Call the login function
                login(
                  emailController.text, // Pass the entered email
                  passwordController.text, // Pass the entered password
                  context, // Pass the current context
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
