import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapScreen extends StatefulWidget {
  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _savedLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getSavedLocation();
  }

  Future<void> _getSavedLocation() async {
    try {
      // Assume the user's email is the document ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('members')
            .doc(user.email)
            .get();
        if (doc.exists) {
          String savedLocation = doc['พิกัด'];
          List<String> latLng = savedLocation.split(',');
          double latitude = double.parse(latLng[0].trim());
          double longitude = double.parse(latLng[1].trim());
          setState(() {
            _savedLocation = LatLng(latitude, longitude);
            _markers.add(
              Marker(
                markerId: MarkerId('savedLocation'),
                position: _savedLocation!,
                infoWindow: InfoWindow(title: 'Saved Location'),
              ),
            );
            if (_mapController != null) {
              _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _savedLocation!,
                    zoom: 17,
                  ),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      print("Failed to get saved location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แผนที่พิกัดที่บันทึกไว้'),
        backgroundColor: const Color.fromARGB(255, 216, 255, 171),
      ),
      body: _savedLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                if (_savedLocation != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _savedLocation!,
                        zoom: 17,
                      ),
                    ),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _savedLocation ?? LatLng(0, 0), // Default position
                zoom: 2,
              ),
              markers: _markers,
            ),
    );
  }
}
