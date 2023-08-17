import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Attraction_details.dart'; // Import the AttractionDetailsPage

class AttractionsPage extends StatefulWidget {
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> _places = [];

  @override
  void initState() {
    super.initState();
    fetchPlaceData();
  }

  void fetchPlaceData() {
    _database.child('places').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? places =
      snapshot.value as Map<dynamic, dynamic>?;
      if (places != null) {
        List<Map<String, dynamic>> placeList = [];
        places.forEach((key, value) {
          // Handle null values
          String name = value['name'] ?? 'Unknown';
          String image = value['image'] ?? ''; // Provide a default image URL
          placeList.add({
            'name': name,
            'image': image,
          });
        });
        setState(() {
          _places = placeList;
        });
      }
    }, onError: (error) {
      print('Error retrieving place data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attractions'),
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
      body: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttractionDetailsPage(
                    attractionName: _places[index]['name'],
                    attractionImage: _places[index]['image'],
                  ),
                ),
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _places[index]['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(_places[index]['name']),
            trailing: const Icon(Icons.arrow_forward),
          );
        },
      ),
    );
  }
}
