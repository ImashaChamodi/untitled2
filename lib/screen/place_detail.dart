import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeName;
  final Map<dynamic, dynamic> details;
  final List<String> feedback;

  PlaceDetailsPage({required this.placeName, required this.details, required this.feedback});

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  void addFeedback() {
    String newFeedback = _feedbackController.text.trim();
    if (newFeedback.isNotEmpty) {
      String placeKey = widget.details['placeKey'];
      _database.child('places/$placeKey/feedback').push().set(newFeedback);
      setState(() {
        widget.feedback.add(newFeedback);
        _feedbackController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Display place details
                ListTile(
                  title: Text('Location'),
                  subtitle: Text(widget.details['location']),
                ),
                ListTile(
                  title: Text('Historical Value'),
                  subtitle: Text(widget.details['historicalValue']),
                ),
                // Display feedback from users
                ListTile(
                  title: Text('Feedback'),
                ),
                for (String feedback in widget.feedback)
                  ListTile(
                    title: Text(feedback),
                  ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      labelText: 'Add Feedback',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addFeedback,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
