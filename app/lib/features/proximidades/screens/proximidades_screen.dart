import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class ProximidadesScreen extends StatefulWidget {
  const ProximidadesScreen({super.key});
  static const String routeName = '/proximidades';

  @override
  State<ProximidadesScreen> createState() => _ProximidadesScreenState();
}

class _ProximidadesScreenState extends State<ProximidadesScreen> {
  LatLng? _currentLatLng;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Serviço de localização desativado.';
          _loading = false;
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Permissão de localização negada.';
            _loading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Permissão de localização negada permanentemente.';
          _loading = false;
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao obter localização: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proximidades')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : FlutterMap(
                  options: MapOptions(
                    center: _currentLatLng,
                    zoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLatLng!,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
