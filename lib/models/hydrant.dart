import 'package:cloud_firestore/cloud_firestore.dart';

class Hydrant {
  Hydrant(
      String ref,
      String firstAttack,
      String secondAttack,
      String pressure,
      String cap,
      String city,
      double lat,
      double long,
      String color,
      DateTime lastCheck,
      String notes,
      String opening,
      String place,
      String streetNumber,
      String type,
      String vehicle) {
    this._reference = ref;
    this._firstAttack = firstAttack;
    this._secondAttack = secondAttack;
    this._pressure = pressure;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = lastCheck;
    this._notes = notes;
    this._opening = opening;
    this._place = place;
    this._streetNumber = streetNumber;
    this._type = type;
    this._vehicle = vehicle;
    this._color = color;
  }

  Hydrant.fromCitizen(
    String cap,
    String city,
    double lat,
    double long,
    String notes,
    String place,
    String streetNumber,
  ) {
    this._reference = "";
    this._firstAttack = "";
    this._secondAttack = "";
    this._pressure = "";
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = DateTime.now();
    this._notes = notes;
    this._opening = "";
    this._place = place;
    this._streetNumber = streetNumber;
    this._type = "";
    this._vehicle = "";
    this._color = "";
  }

  Hydrant.fromFireman(
      String firstAttack,
      String secondAttack,
      String pressure,
      String cap,
      String city,
      double lat,
      double long,
      String color,
      DateTime lastCheck,
      String notes,
      String opening,
      String place,
      String streetNumber,
      String type,
      String vehicle) {
    this._reference = "";
    this._firstAttack = firstAttack;
    this._secondAttack = secondAttack;
    this._pressure = pressure;
    this._cap = cap;
    this._city = city;
    this._lat = lat;
    this._long = long;
    this._lastCheck = lastCheck;
    this._notes = notes;
    this._opening = opening;
    this._place = place;
    this._streetNumber = streetNumber;
    this._type = type;
    this._vehicle = vehicle;
    this._color = color;
  }

  String _reference;
  String _firstAttack;
  String _secondAttack;
  String _pressure;
  String _cap;
  String _city;
  double _lat;
  double _long;
  String _color;
  DateTime _lastCheck;
  String _notes;
  String _opening;
  String _place;
  String _streetNumber;
  String _type;
  String _vehicle;

  String getColor() {
    return _color;
  }

  String getFirstAttack() {
    return _firstAttack;
  }

  String getSecondAttack() {
    return _secondAttack;
  }

  String getPressure() {
    return _pressure;
  }

  String getCap() {
    return _cap;
  }

  String getCity() {
    return _city;
  }

  double getLat() {
    return _lat;
  }

  double getLong() {
    return _long;
  }

  DateTime getLastCheck() {
    return _lastCheck;
  }

  String getNotes() {
    return _notes;
  }

  String getOpening() {
    return _opening;
  }

  String getPlace() {
    return _place;
  }

  String getStreetNumber() {
    return _streetNumber;
  }

  String getType() {
    return _type;
  }

  String getVehicle() {
    return _vehicle;
  }

  String getDBReference() {
    return _reference;
  }
}
