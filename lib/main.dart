import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebhookScreen(),
    );
    
  }
}

class WebhookScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Future<void> sendWebhook(String message) async {
    const String url = 'http://localhost:8080/webhook'; // Server URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );
      print('Response: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Webhook Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendWebhook(_controller.text);
              },
              child: Text('Send Webhook'),
            ),
          ],
        ),
      ),
    );
  }
}

