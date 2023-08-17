import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'booking_details.dart'; // Import the BookingDetailsPage

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> hotel;

  BookingPage({required this.hotel});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _currentImageIndex = 0;
  double _userRating = 0.0;
  TextEditingController _feedbackController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.hotel['images'] != null ? List<String>.from(
        widget.hotel['images']) : [];

    // Extract latitude and longitude from the location map
    double latitude = widget.hotel['location']['latitude'] ?? 0.0;
    double longitude = widget.hotel['location']['longitude'] ?? 0.0;
    LatLng hotelLocation = LatLng(latitude, longitude);

    return Scaffold(
        appBar: AppBar(
          title: Text('Hotels Details'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      widget.hotel['name'] ?? '', // Handle null hotel name
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                                (index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundColor: _currentImageIndex == index
                                      ? Colors.blue
                                      : Colors.grey,
                                  radius: 4.0,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Address: ${widget.hotel['address'] ?? ''}'),
              SizedBox(height: 16),
              Text('Nearest City: ${widget.hotel['nearestCity'] ?? ''}'),
              SizedBox(height: 16),
              Text(
                'Room Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('Type'),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('Amount'),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('Price'),
                        ),
                      ),
                    ],
                  ),
                  for (var roomType in widget.hotel['roomTypes'] ?? [])
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(roomType['type'] ?? ''),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(roomType['amount'] ?? ''),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(roomType['price'] ?? ''),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 200.0,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: hotelLocation, zoom: 15),
                  markers: {
                    Marker(
                      markerId: MarkerId('hotelLocation'),
                      position: hotelLocation,
                    ),
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate Us',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 1,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 24.0,
                      itemBuilder: (context, _) =>
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _userRating = rating;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Feedback...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Save the rating and feedback to the database
                        // saveRatingAndFeedbackToDatabase(widget.hotel['hotel']);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Book Now button with navigation
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(hotel: widget.hotel),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text('Book Now'),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// void saveRatingAndFeedbackToDatabase(String hotelId) {
  //   if (hotelId.isEmpty) {
  //     print('Error: Hotel ID is empty.');
  //     return;
  //   }
  //
  //   // Save the user's rating and feedback to the 'ratings' and 'feedback' nodes under the corresponding hotel entry in the Firebase Realtime Database
  //   DatabaseReference hotelRef = _databaseReference.child('hotels').child(
  //       hotelId);
  //   hotelRef.child('ratings').push().set(_userRating);
  //   hotelRef.child('feedback').push().set(_feedbackController.text);
  //
  //   // Log the data for verification
  //   print('Rating: $_userRating');
  //   print('Feedback: ${_feedbackController.text}');
  //   print('Hotel ID: $hotelId');
  //
  //   // Display a toast message
  //   Fluttertoast.showToast(
  //     msg: 'Thank you for your feedback!',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.black54,
  //     textColor: Colors.white,
  //   );
  // }

