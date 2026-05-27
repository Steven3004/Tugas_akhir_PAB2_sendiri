import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/post.dart';

class MapDetailScreen extends StatelessWidget {
  final Post post;

  const MapDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final double latitude = post.latitude ?? 0;

    final double longitude = post.longitude ?? 0;

    final LatLng location = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Postingan')),

      body: latitude == 0 && longitude == 0
          ? const Center(child: Text('Lokasi tidak tersedia'))
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(initialCenter: location, initialZoom: 15),

                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                      userAgentPackageName: 'com.studybuddy.app',
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,

                          width: 80,

                          height: 80,

                          child: const Icon(
                            Icons.location_pin,

                            size: 60,

                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  bottom: 20,

                  left: 20,

                  right: 20,

                  child: Card(
                    elevation: 5,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            post.title ?? 'No Title',

                            style: const TextStyle(
                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(post.description ?? ''),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  'Lat: ${latitude.toStringAsFixed(5)}\nLng: ${longitude.toStringAsFixed(5)}',

                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
