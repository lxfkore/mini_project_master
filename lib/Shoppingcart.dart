Import 'package:flutter/material.dart';


class ShoppingCartPage extends StatefulWidget {
  final Map<String, int> cartItems;


  const ShoppingCartPage({super.key, required this.cartItems});


  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}


class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Your Cart',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'), // Replace with the actual image
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: widget.cartItems.keys.map((item) {
                  return _buildCartItem(item);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle checkout or cart completion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Background color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Done',
                  style: TextStyle(
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }


  // Helper method to build cart items as per the design
  Widget _buildCartItem(String item) {
    String description = '';
    double price = 0.0;
    String imageUrl = '';


    switch (item) {
      case 'Spaghetti':
        price = 10.0;
        description = 'With Meatballs';
        imageUrl = 'https://example.com/spaghetti.png'; // Replace with actual image URL
        break;
      case 'Cappuccino':
        price = 3.14;
        description = 'With Chocolate';
        imageUrl = 'https://example.com/cappuccino.png'; // Replace with actual image URL
        break;
      case 'Aglio Olio':
        price = 9.5;
        description = 'With Tomatoes';
        imageUrl = 'https://example.com/aglio_olio.png'; // Replace with actual image URL
        break;
    }


    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: true,
              onChanged: (bool? newValue) {},
              activeColor: Colors.orange,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Add function to increase quantity
                    setState(() {
                      widget.cartItems[item] = (widget.cartItems[item]! + 1);
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.orange),
                ),
                Text(
                  '${widget.cartItems[item]}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    // Add function to decrease quantity
                    setState(() {
                      if (widget.cartItems[item]! > 1) {
                        widget.cartItems[item] = (widget.cartItems[item]! - 1);
                      } else {
                        widget.cartItems.remove(item);
                      }
                    });
                  },
                  icon: const Icon(Icons.remove, color: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 1) {
          // Handle cart navigation
        }
      },
    );
  }
}
