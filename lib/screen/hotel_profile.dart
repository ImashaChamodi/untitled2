import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RoomType {
  String type;
  String amount;
  String price;

  RoomType({required this.type, required this.amount, required this.price});
}

class HotelProfilePage extends StatefulWidget {
  @override
  _HotelProfilePageState createState() => _HotelProfilePageState();
}

class _HotelProfilePageState extends State<HotelProfilePage> {
  TextEditingController _hotelNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nearestCityController = TextEditingController();
  List<RoomType> _roomTypes = [];
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  List<File> _imageFiles = [];
  Set<Marker> _markers = {};
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool _isEditing = true;

  @override
  void dispose() {
    _hotelNameController.dispose();
    _addressController.dispose();
    _nearestCityController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(location));

    final newMarker = Marker(
      markerId: MarkerId('selectedLocation'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      draggable: true, // Make the marker draggable
      onDragEnd: (newPosition) {
        setState(() {
          _selectedLocation = newPosition;
        });
      },
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'selectedLocation');
      _markers.add(newMarker);
    });
  }

  void _saveHotelProfile() async {
    // Get the form values
    String hotelName = _hotelNameController.text;
    String address = _addressController.text;
    String nearestCity = _nearestCityController.text;

    // Prepare the data to be saved
    Map<String, dynamic> hotelData = {
      'hotelName': hotelName,
      'address': address,
      'nearestCity': nearestCity,
      'images': [], // List to store image URLs
      'location': {
        'latitude': _selectedLocation?.latitude ?? 0.0,
        'longitude': _selectedLocation?.longitude ?? 0.0,
      },
      'roomTypes': _roomTypes.map((roomType) => {
        'type': roomType.type,
        'amount': roomType.amount,
        'price': roomType.price,
      }).toList(),
    };

    try {
      // Save the images to storage and get their URLs
      List<String> imageUrls = await _uploadImages();

      // Add the image URLs to the hotel data
      hotelData['images'] = imageUrls;

      // Save the data to the database
      DatabaseReference newHotelRef = _database.child('hotels').push();
      await newHotelRef.set(hotelData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel profile saved successfully')),
      );

      if (!_isEditing) {
        // Navigate to hotel_home.dart if not in editing mode
        Navigator.pushReplacementNamed(context, '/hotel_home');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save hotel profile: $error')),
      );
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (var imageFile in _imageFiles) {
      // Upload each image file to storage and get the URL
      String imageUrl = await _uploadImage(imageFile);
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('hotel_images/$fileName.jpg');

    await ref.putFile(imageFile);
    String imageUrl = await ref.getDownloadURL();

    return imageUrl;
  }

  Future<void> _pickImages() async {
    List<File> pickedImages = [];

    try {
      List<Asset> assets = await MultiImagePicker.pickImages(
        maxImages: 9 - _imageFiles.length,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: '#abcdef',
          actionBarTitle: 'Select Images',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor: '#000000',
        ),
      );

      for (var asset in assets) {
        File? file = await _convertAssetToFile(asset);
        if (file != null) {
          pickedImages.add(file);
        }
      }

      setState(() {
        _imageFiles.addAll(pickedImages);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<File?> _convertAssetToFile(Asset asset) async {
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/${asset.name}');
    await tempFile.writeAsBytes(imageData);
    return tempFile;
  }

  void _addRoomType() {
    setState(() {
      _roomTypes.add(RoomType(type: '', amount: '', price: ''));
    });
  }

  void _removeRoomType(int index) {
    setState(() {
      _roomTypes.removeAt(index);
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Profile'),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _hotelNameController,
                decoration: InputDecoration(
                  labelText: 'Hotel Name',
                ),
                enabled: _isEditing, // Disable editing when not in editing mode
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Hotel Address',
                ),
                enabled: _isEditing, // Disable editing when not in editing mode
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nearestCityController,
                decoration: InputDecoration(
                  labelText: 'Nearest City',
                ),
                enabled: _isEditing, // Disable editing when not in editing mode
              ),
              SizedBox(height: 16.0),

              // Map widget
              Container(
                height: 200.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0.0, 0.0),
                    zoom: 10.0,
                  ),
                  markers: _markers,
                ),
              ),
              SizedBox(height: 16.0),

              // Add Room Types
              Text(
                'Room Types',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),

              ListView.builder(
                shrinkWrap: true,
                itemCount: _roomTypes.length,
                itemBuilder: (context, index) {
                  return RoomTypeFormField(
                    roomType: _roomTypes[index],
                    onRemove: () => _removeRoomType(index),
                    isEditing: _isEditing, // Pass the editing mode to the form field
                  );
                },
              ),

              ElevatedButton(
                onPressed: _addRoomType,
                child: Text('Add Room Type'),
              ),

              // Image Grid
              Text(
                'Images',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(_imageFiles.length + 1, (index) {
                  if (index == 0) {
                    return IconButton(
                      onPressed: () {
                        _pickImages();
                      },
                      icon: Icon(Icons.add),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      // Implement code to show full-size image
                    },
                    child: Image.file(
                      _imageFiles[index - 1],
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    _saveHotelProfile();
                    _toggleEditing(); // Save and toggle to non-editing mode
                  } else {
                    _toggleEditing(); // Toggle to editing mode
                  }
                },
                child: Text(_isEditing ? 'Save Profile' : 'Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomTypeFormField extends StatelessWidget {
  final RoomType roomType;
  final VoidCallback onRemove;
  final bool isEditing; // Added the isEditing parameter

  RoomTypeFormField({
    required this.roomType,
    required this.onRemove,
    required this.isEditing, // Accept the isEditing parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: roomType.type,
          decoration: InputDecoration(
            labelText: 'Room Type',
          ),
          onChanged: (value) {
            if (isEditing) { // Only update the value if in editing mode
              roomType.type = value;
            }
          },
          enabled: isEditing, // Disable editing when not in editing mode
        ),
        TextFormField(
          initialValue: roomType.amount,
          decoration: InputDecoration(
            labelText: 'Amount',
          ),
          onChanged: (value) {
            if (isEditing) { // Only update the value if in editing mode
              roomType.amount = value;
            }
          },
          enabled: isEditing, // Disable editing when not in editing mode
        ),
        TextFormField(
          initialValue: roomType.price,
          decoration: InputDecoration(
            labelText: 'Price',
          ),
          onChanged: (value) {
            if (isEditing) { // Only update the value if in editing mode
              roomType.price = value;
            }
          },
          enabled: isEditing, // Disable editing when not in editing mode
        ),
        if (isEditing) // Show Remove button only when in editing mode
          ElevatedButton(
            onPressed: onRemove,
            child: Text('Remove'),
          ),
        Divider(),
      ],
    );
  }
}
