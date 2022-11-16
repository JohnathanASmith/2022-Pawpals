import 'dart:math';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:location/location.dart';
import 'package:paw_pals/models/post_model.dart';
import 'package:paw_pals/models/pref_model.dart';

/// Location service class for geohashing and other location-based actions.
/// <br /><br />
/// **Helpful Links**
/// * <a href="https://pub.dev/packages/location">Location Package (installed)</a>
/// * <a href="https://pub.dev/packages/flutter_geo_hash">Geohash Package (installed)</a>
/// * <a href="https://gis.stackexchange.com/questions/115280/what-is-the-precision-of-geohash">What is the precision of Geohash?</a>
class LocationService {
  /// Gets the users location. This also handles asking for permission to use
  /// location and the things like that. Returns the longitude, latitude and
  /// a geoHash of the users location.
  static getLocation() async {
    Location location = new Location();

    MyGeoHash myGeoHash = MyGeoHash();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    String? hash = myGeoHash.geoHashForLocation(
        GeoPoint(_locationData.latitude!, _locationData.longitude!));

    return OurLocation(
        latitude: _locationData.latitude,
        longitude: _locationData.longitude,
        geoHash: hash);
  }

  /// used to get the new list of post models for the screen
  /// based on the search radius
  /// returns a list of post models
  static updatePostListWithSearchRadius(
      {required List<PostModel> oldPostModelList,
      required Future<PreferencesModel?> userPreferenceModel}) async {
    print('List length before search radius: ${oldPostModelList.length}');
    PostModel postModel;
    double postModelDistance;
    List<PostModel> newPostModelList = [];
    OurLocation userLocation = await getLocation();
    int? searchRadius;
    userPreferenceModel
        .then((value) => searchRadius = value?.searchRadius)
        .then(
            (value) => print('Checking to see if posts are <= $searchRadius miles away'));
    searchRadius ??= 150;

    for (postModel in oldPostModelList) {
      postModelDistance = await getDistance(
          userLatitude: userLocation.latitude,
          userLongitude: userLocation.longitude,
          postLatitude: postModel.latitude,
          postLongitude: postModel.longitude);
      if (postModelDistance <= searchRadius!) {
        print('Current post distance from user: ${postModelDistance}');
        newPostModelList.add(postModel);
      }
    }
    print('List length after search radius: ${newPostModelList.length}');

    return newPostModelList;
  }

  /// function to get the distance between two pairs of coordinates
  /// returns distance in miles
  static getDistance(
      {userLatitude, userLongitude, postLatitude, postLongitude}) {
    /// function to compute distance
    double calculateDistance({userLat, userLong, postLat, postLong}) {
      var p = 0.017453292519943295;
      var a = 0.5 -
          cos((postLat - userLat) * p) / 2 +
          cos(userLat * p) *
              cos(postLat * p) *
              (1 - cos((postLong - userLong) * p)) /
              2;
      return 12742 * asin(sqrt(a));
    }

    return calculateDistance(
        userLat: userLatitude,
        userLong: userLongitude,
        postLat: postLatitude,
        postLong: postLongitude);
  }
}

/// Use something like this to return
/// from LocationService.getLocation()
class OurLocation {
  double? longitude;
  double? latitude;
  String? geoHash;
  OurLocation(
      {required this.longitude, required this.latitude, required this.geoHash});
}