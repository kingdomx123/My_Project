import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  GoogleMapController? _controller;
  LatLng _selectedLocation = LatLng(19.0308, 99.9263);
  Marker? _marker;
  Position? _currentPosition;
  final TextEditingController _addressController = TextEditingController();

  Future<void> _searchAddress() async {
    String address = _addressController.text;
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng target = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedLocation = target;
          _marker = Marker(
            markerId: MarkerId(address),
            position: target,
            infoWindow: InfoWindow(
              title: address,
            ),
          );
        });

        mapController.animateCamera(CameraUpdate.newLatLng(target));
      } else {
        // ไม่พบที่อยู่
        _showErrorDialog("ไม่พบที่อยู่");
      }
    } catch (e) {
      _showErrorDialog("ไม่พบที่อยู่");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_selectedLocation));
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ข้อผิดพลาด"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกที่อยู่ของท่าน'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              String address = await _getAddressFromLatLng(_selectedLocation);
              Navigator.pop(context, address);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาที่อยู่ของท่าน',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchAddress,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 17,
              ),
              onTap: (position) {
                setState(() {
                  _selectedLocation = position;
                });
              },
              markers: {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedLocation,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
      return "ไม่ทราบตำแหน่ง";
    }
  }
}
