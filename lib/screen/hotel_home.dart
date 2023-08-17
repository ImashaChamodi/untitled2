import 'package:flutter/material.dart';
import 'hotel_booking.dart';
import 'hotel_profile.dart';

class HotelHomePage extends StatelessWidget {
  const HotelHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back arrow button press
            Navigator.pop(context);
          },
        ),
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
              child: Image.asset(
                'assets/welcome hotel.jpg', // Replace with your welcome image
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome to Travel Lanka!\n\nWe are your travel companions in Sri Lanka, dedicated to providing an exceptional experience to tourists visiting our beautiful country. Our mobile application serves as a platform for hotels to showcase their details to tourists. By registering and creating a profile, your hotel will be displayed to potential tourists, making it easier for you to connect with new customers and manage bookings efficiently.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the hotel profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotelProfilePage()),
                );
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF8AA30D), // Set the button color
                textStyle: TextStyle(fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.home), // Home icon added
                  onPressed: () {
                    // Handle home icon press
                    // Navigate to the home page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotelHomePage()),
                    );
                  },
                ),
                Text('Home'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.hotel),
                  onPressed: () {
                    // Handle booking icon press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotelBookingPage()),
                    );
                  },
                ),
                Text('Booking'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person_outline),
                  onPressed: () {
                    // Handle profile icon press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HotelProfilePage()),
                    );
                  },
                ),
                Text('Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



