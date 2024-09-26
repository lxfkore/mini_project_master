import 'package:flutter/material.dart';
import 'dart:async';

class OrderProcessPage extends StatefulWidget {
  @override
  _OrderProcessPageState createState() => _OrderProcessPageState();
}

class _OrderProcessPageState extends State<OrderProcessPage> {
  bool _isOrderFailed = false;
  bool _cancelEnabled = false;

  @override
  void initState() {
    super.initState();
    // Simulate the waiting time before cancel button is enabled
    Timer(Duration(seconds: 5), () {
      setState(() {
        _cancelEnabled = true;
      });
    });

    // Simulate order failure (for demonstration)
    Timer(Duration(seconds: 10), () {
      setState(() {
        _isOrderFailed = true;
      });
    });
  }

  // Function to simulate cancel order
  void _cancelOrder() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order has been cancelled"))
    );
  }

  // Function to navigate to the Order Status Page
  void _navigateToOrderStatus() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderStatusPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Process"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _isOrderFailed
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Order not successful.", style: TextStyle(fontSize: 18, color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go Back"),
            )
          ],
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.kitchen, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            Text("Your order is being prepared", style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _navigateToOrderStatus,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Button color to match the image
                  ),
                  child: Text("Details"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _cancelEnabled ? _cancelOrder : null,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  child: Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
