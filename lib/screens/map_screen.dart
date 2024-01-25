import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/auth_modal/auth_modal.dart';

class Data {
  Data({
    this.latitude = '',
    this.longitude = '',
    required this.dust,
    required this.vending,
    required this.id,
  });

  final String? latitude;
  final String longitude;
  final bool dust;
  final bool vending;
  final String id;

  factory Data.fromDoc(String id, Map<String, dynamic> doc) => Data(
    latitude: doc['latitude'],
    longitude: doc['longitude'],
    dust: doc['dust'],
    vending: doc['vending'],
    id: id,
  );
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  // 現在地を監視するためのStream
  late StreamSubscription<Position> positionStream;
  Set<Marker> markers = {};

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 16.0,
  );

  late Position currentPosition;


  // 現在地通知の設定
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0,
  );


  // ------------  Users  ------------
  late StreamSubscription<List<Data>> dataStream;

  // ------------  Methods for Markers  ------------
  void _watchUsers() {
    dataStream = getDataStream().listen((datas) {
      _setDataMarkers(datas);
    });
  }

  @override
  void initState() {
    _watchUsers();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    // Streamを閉じる
    positionStream.cancel();
    dataStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) async {
          mapController = controller;
          await _requestPermission();
          await _moveToCurrentLocation();
          _watchCurrentLocation();
        },
        myLocationButtonEnabled: false,
        markers: markers,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              builder: (BuildContext context) {
                return AuthModal(currentPosition);
              });
        },
        label: const Text('登録'),
      ),
    );
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
        ));
      });

      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }


  void _watchCurrentLocation() {
    // 現在地を監視
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) async {
          // マーカーの位置を更新
          setState(() {
            markers.removeWhere(
                    (marker) => marker.markerId == const MarkerId('current_location'));

            currentPosition = position;

            markers.add(Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(
                position.latitude,
                position.longitude,
              ),
            ));
          });
          // 現在地にカメラを移動
          await mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16,
              ),
            ),
          );
        });
  }



  Stream<List<Data>> getDataStream() {
    return FirebaseFirestore.instance.collection('data').snapshots().map(
          (snp) => snp.docs
          .map((doc) => Data.fromDoc(doc.id, doc.data()))
          .toList(),
    );
  }
  void _setDataMarkers(List<Data> datas) {
    final dvs = datas.where((data) => data.vending == true || data.dust == true).toList();

    for (final dv in dvs) {
        final String lat = dv.latitude!;
        final String lng = dv.longitude!;
        setState(() {
          // 既にマーカーが作成されている場合は、取り除く
          if (markers
              .where((m) => m.markerId == MarkerId(dv.id!))
              .isNotEmpty) {
            markers.removeWhere(
                  (marker) => marker.markerId == MarkerId(dv.id!),
            );
          }
          // 取り除いた上でマーカーを追加
          if(dv.vending == true){
            markers.add(Marker(
              markerId: MarkerId(dv.id!),
              position: LatLng(double.parse(lat), double.parse(lng)),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow,
              ),
            ));
          }
          if(dv.dust == true){
            markers.add(Marker(
              markerId: MarkerId(dv.id!),
              position: LatLng(double.parse(lat), double.parse(lng)),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ));
          }
          if(dv.dust == true && dv.vending == true){
            markers.add(Marker(
              markerId: MarkerId(dv.id!),
              position: LatLng(double.parse(lat), double.parse(lng)),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ));
          }
        });
      }
  }
}