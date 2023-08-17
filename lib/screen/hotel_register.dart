import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/screen/hotel_login.dart';

class HotelRegisterPage extends StatefulWidget {
  @override
  _HotelRegisterPageState createState() => _HotelRegisterPageState();
}

class _HotelRegisterPageState extends State<HotelRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hotelNameController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Registration'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hotel Registration',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            child: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _hotelNameController,
                        decoration: InputDecoration(
                          labelText: 'Hotel Name',
                          icon: Icon(Icons.hotel),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the hotel name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final UserCredential userCredential =
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              if (userCredential.user != null) {
                                // Perform additional hotel registration logic
                                // For example, store hotel name in Firestore
                                // ...

                                // Show a SnackBar to indicate successful registration
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Registration successful! You can now log in.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );

                                // Navigate to hotel login page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HotelLoginPage()),
                                );
                              }
                            } catch (e) {
                              print("Error: $e");
                              // Handle registration error
                            }
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
