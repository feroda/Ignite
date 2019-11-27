import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:ignite/models/app_state.dart';
import 'package:ignite/widgets/homepage_button.dart';
import 'package:ignite/widgets/hydrant_card.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'loading_screen.dart';

class CitizenScreen extends StatefulWidget {
  String jsonStyle;
  LatLng position;

  CitizenScreen({
    @required this.position,
    @required this.jsonStyle,
  });

  @override
  _CitizenScreenState createState() => _CitizenScreenState();
}

class _CitizenScreenState extends State<CitizenScreen> {
  StreamSubscription<Position> _positionStream;
  GoogleMapController _mapController;
  Set<Marker> _markerSet = Set();
  double _zoomCameraOnMe = 18.0;
  Marker resultMarker;
  Widget _bodyWidget;

  @override
  void initState() {
    super.initState();
    this.setupPositionStream();
    this._bodyWidget = _mapBody();
  }

  void setupPositionStream() {
    _positionStream = Geolocator()
        .getPositionStream(
      LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000),
    )
        .listen((pos) {
      widget.position = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _addMarker() {
    setState(() {
      _markerSet.add(resultMarker);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(widget.jsonStyle);
      this._addMarker();
    });
  }

  void _animateCameraOnMe() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: _zoomCameraOnMe,
      ),
    ));
  }

  Widget _getProfileSettings() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            FloatingActionButton(
              child: Container(
                height: 200,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mapBody() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapToolbarEnabled: false,
          indoorViewEnabled: true,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: _onMapCreated,
          markers: _markerSet,
          initialCameraPosition: CameraPosition(
            target: widget.position,
            zoom: _zoomCameraOnMe,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            right: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  HomePageButton(
                    function: _animateCameraOnMe,
                    icon: Icons.gps_fixed,
                    heroTag: 'GPS',
                  ),
                  HomePageButton(
                    heroTag: 'THEME',
                    icon: Icons.autorenew,
                    function: () {
                      ThemeProvider.controllerOf(context).nextTheme();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoadingScreen(),
                        ),
                      );
                    },
                  ),
                  HomePageButton(
                    heroTag: 'LOGOUT',
                    icon: Icons.backspace,
                    function: () {
                      Provider.of<AppState>(context).logOut(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          ThemeProvider.optionsOf<CustomOptions>(context).brightness,
      systemNavigationBarColor:
          ThemeProvider.themeOf(context).data.bottomAppBarColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor:
          ThemeProvider.themeOf(context).data.bottomAppBarColor,
    ));

    resultMarker = Marker(
      markerId: MarkerId(
        "Primo idrante",
      ),
      position: LatLng(0, 0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HydrantCard()),
        );
      },
    );

    return Scaffold(
      extendBody: true,
      body: _bodyWidget,
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          index: 1,
          color: ThemeProvider.themeOf(context).data.bottomAppBarColor,
          animationDuration: Duration(
            milliseconds: 500,
          ),
          buttonBackgroundColor:
              ThemeProvider.themeOf(context).data.bottomAppBarColor,
          items: <Icon>[
            Icon(
              Icons.terrain,
              size: 35,
              color: ThemeProvider.themeOf(context).data.buttonColor,
            ),
            Icon(
              Icons.add,
              size: 35,
              color: ThemeProvider.themeOf(context).data.buttonColor,
            ),
            Icon(
              Icons.person,
              size: 35,
              color: ThemeProvider.themeOf(context).data.buttonColor,
            ),
          ],
          onTap: (index) {
              switch (index) {
                case 0:
                  setState(() {_bodyWidget = _getProfileSettings();});
                  break;
                case 1:
                  setState(() {_bodyWidget = _mapBody();}); 
            }
          }),
    );
  }
}