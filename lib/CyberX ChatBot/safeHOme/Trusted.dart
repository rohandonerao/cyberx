// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cyberx/contactcm.dart';
import 'package:cyberx/db_services.dart';
import 'package:url_launcher/url_launcher.dart';

class Trusted extends StatefulWidget {
  @override
  State<Trusted> createState() => _TrustedState();
}

class _TrustedState extends State<Trusted> {
  Position? _currentPosition;
  String? _currentAddress;
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  Future<void> _getPermission() async {
    await Permission.location.request();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromLatLon();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _getAddressFromLatLon() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.street}";
          _markers.clear();
          _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            infoWindow: InfoWindow(title: _currentAddress!),
          ));
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR TRUSTED PERSON",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                if (_currentPosition != null) Text(_currentAddress!),
                SizedBox(height: 10),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude)
                          : LatLng(0, 0),
                      zoom: 15,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
                ),
                SizedBox(height: 10),
                PrimaryButtonWidget(
                  title: "GET LOCATION",
                  onPressed: _getCurrentLocation,
                ),
                SizedBox(height: 10),
                PrimaryButtonWidget(
                  title: "SEND LOCATION",
                  onPressed: _handleAlert,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 65, 134, 177),
                Color.fromARGB(255, 208, 125, 179),
                Color.fromARGB(255, 228, 226, 223),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleAlert() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
    if (contactList.isEmpty) {
      Fluttertoast.showToast(msg: "Emergency contacts list is empty");
      return;
    }

    String messageBody =
        "I am sharing safe location. I am here at $_currentAddress. My location is: https://www.google.com/maps/place/${_currentPosition?.latitude},${_currentPosition?.longitude}";

    String contactsString =
        contactList.map((contact) => contact.number).join(",");

    String smsUrl = "sms:$contactsString?body=$messageBody";

    try {
      if (await canLaunch(smsUrl)) {
        await launch(smsUrl);
      } else {
        throw 'Could not launch $smsUrl';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to open messaging app");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        child: InkWell(
          onTap: () => showModelSafeHome(context),
          child: Container(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 224, 45, 161),
                        Color.fromARGB(255, 187, 203, 206),
                        Color.fromARGB(255, 146, 144, 143),
                      ],
                    )),
                height: 200,
                width: 370,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'SEND LOCATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text("Share your location",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18, right: 127, left: 10),
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'SHARE',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.050,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Image.asset(
                          'assets/logo/route.png',
                          height: 170,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButtonWidget extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool loading;

  PrimaryButtonWidget({
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
