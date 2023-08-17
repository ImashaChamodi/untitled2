import 'package:flutter/material.dart';
import 'hotel.dart';
import 'attractions.dart';
import 'map_screen.dart';
import 'logout.dart';
import 'list.dart';
import 'chatbot_widget.dart'; // Import the ChatbotWidget


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isAttractionSelected = true; // To track whether attraction is selected

  @override
  void initState() {
    super.initState();
    // Periodically change the selected state after a delay
    _changeSelectedState();
  }

  void _changeSelectedState() {
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        _isAttractionSelected = !_isAttractionSelected;
      });
      _changeSelectedState();
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AttractionsPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelPage()),
        );
        break;
    }
  }



  void _navigateToLogout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogoutPage()),
    );
  }

  void _navigateToChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()), // Use the ChatbotWidget here
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TravelLanka'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _navigateToLogout,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8AA30D),
                Color(0xFF0D53A3),
                // Colors.pink.shade800
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Home'),
              decoration: BoxDecoration(
                color: Color(0xFF8AA30D),
              ),
            ),
            ListTile(
              title: Text('Attractions'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              title: Text('Hotels'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _navigateToLogout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                width: double.infinity,
                child: Image.asset(
                  _isAttractionSelected
                      ? 'assets/attraction_image.jpg'
                      : 'assets/hotel_image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                _isAttractionSelected ? 'Attractions' : 'Hotels',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                child: Text(
                    _isAttractionSelected
                        ? 'Sri Lanka, often referred to as the "Pearl of the Indian Ocean," is a mesmerizing destination that boasts an array of captivating tourist attractions...'
                        : 'Nature enthusiasts can indulge in eco-friendly lodges nestled within or near national parks...',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 100), // Add some spacing between the container and chatbot icon
      FloatingActionButton(
        onPressed: _navigateToChatbot,
        tooltip: 'Chatbot',
        child: Icon(Icons.chat, size: 56), // Increase the icon size
      ),
      ],
    ),
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attractions),
            label: 'Attractions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _navigateToChatbot,
      //   tooltip: 'Chatbot',
      //   child: Icon(Icons.chat),
      // ),
    );
  }
}
