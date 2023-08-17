import 'package:flutter/material.dart';

class HotelBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8AA30D),
                Color(0xFF0D53A3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bookings in coming days',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of bookings
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Booking ${index + 1}'),
                  subtitle: Text('Date: ${DateTime.now().toString()}'), // Replace with actual booking details
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
