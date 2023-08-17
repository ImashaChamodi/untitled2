import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> hotel;

  BookingDetailsPage({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Center(
        child: Text('Booking details for ${hotel['name']}'),
      ),
    );
  }
}
