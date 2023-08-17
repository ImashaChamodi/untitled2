import 'package:flutter/material.dart';

class AttractionDetailsPage extends StatelessWidget {
  final String attractionName;
  final String attractionImage;

  AttractionDetailsPage({
    required this.attractionName,
    required this.attractionImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attraction Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Attraction: $attractionName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.network(
              attractionImage,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            // Add more details here...
          ],
        ),
      ),
    );
  }
}
