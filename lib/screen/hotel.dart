import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'booking.dart';

class HotelPage extends StatefulWidget {
  @override
  _HotelPageState createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  List<Map<String, dynamic>> _hotelList = [];
  List<Map<String, dynamic>> _filteredHotelList = [];
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    retrieveHotels();
  }

  void retrieveHotels() {
    _databaseReference.child('hotels').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _hotelList = values.values.map((value) {
            List<dynamic>? images = value['images'];
            String imageUrl = '';
            if (images != null && images.isNotEmpty) {
              imageUrl = images[0]; // Use the first image URL
            } else {
              // Set a default image URL if no images are available
              imageUrl = 'https://example.com/default_image.jpg';
            }
            return {
              'key': value['key'], // Include the hotel key
              'name': value['hotelName'] ?? 'Hotel Name Not Available',
              'nearestCity': value['nearestCity'] ?? 'City Not Available',
              'imageUrl': imageUrl,
              'location': value['location'], // Include location details
              'address': value['address'], // Include address
              'roomTypes': value['roomTypes'], // Include room types
              'images': images, // Include all images
            };
          }).toList();

          // Sort the hotels list based on hotel names in alphabetical order
          _hotelList.sort((a, b) => a['name'].compareTo(b['name']));

          // Initially, show all hotels
          _filteredHotelList = List.from(_hotelList);

          // Print the retrieved hotel data
          print('Retrieved ${_hotelList.length} hotels:');
          _hotelList.forEach((hotel) {
            print('Hotel Name: ${hotel['name']}');
            print('Nearest City: ${hotel['nearestCity']}');
            print('Image URL: ${hotel['imageUrl']}');
            print('Location: ${hotel['location']}');
            print('Address: ${hotel['address']}');
            print('Room Types: ${hotel['roomTypes']}');
            print('Images: ${hotel['images']}');
            print('---');
          });
        });
      }
    });
  }

  void filterHotels(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _filteredHotelList = _hotelList
            .where((hotel) =>
        hotel['name'].toLowerCase().contains(query.toLowerCase()) ||
            hotel['nearestCity'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        // Show all hotels when the query is empty
        _filteredHotelList = List.from(_hotelList);
      }
    });
  }

  void navigateToBookingPage(Map<String, dynamic> hotel) {
    // Navigate to the booking page and pass the hotel details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(hotel: hotel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterHotels,
              decoration: InputDecoration(
                hintText: 'Search by hotel name or city',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _filteredHotelList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () => navigateToBookingPage(_filteredHotelList[index]), // Pass complete hotel details
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            _filteredHotelList[index]['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _filteredHotelList[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_filteredHotelList[index]['nearestCity']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
