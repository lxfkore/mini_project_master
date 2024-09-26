import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer class

class OrderStatusPage extends StatefulWidget {
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  double _progress = 0.3; // Initial progress value (e.g., 30%)

  @override
  void initState() {
    super.initState();
    // Simulate progress updating
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress = (_progress + 0.3).clamp(0.0, 1.0); // Ensure progress doesn't exceed 1.0
        });
      } else {
        timer.cancel(); // Stop updating progress once it reaches 100%
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Status"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            Text("Order Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.kitchen, color: _progress >= 0.3 ? Colors.orange : Colors.grey),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _progress,
                    color: Colors.orangeAccent,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Icon(Icons.delivery_dining, color: _progress == 1.0 ? Colors.orange : Colors.grey),
              ],
            ),
            SizedBox(height: 40),

            // Order Details
            Text("Order Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Item 1: \$10.00"),
            Text("Item 2: \$5.00"),
            Text("Tax: \$1.50"),
            Text("Total: \$16.50"),
            SizedBox(height: 20),
            Text("Transaction Date: 15th Sept, 2024"),
            SizedBox(height: 40),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Corrected from 'primary' to 'backgroundColor'
                ),
                child: Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
