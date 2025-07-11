// lib/screens/detail_kampus_screen.dart

import 'package:app_kampus/models/kampus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailKampusScreen extends StatelessWidget {
  final Kampus kampus;
  const DetailKampusScreen({super.key, required this.kampus});

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = LatLng(kampus.latitude, kampus.longitude);
    final Marker kampusMarker = Marker(
      markerId: MarkerId(kampus.id.toString()),
      position: initialPosition,
      infoWindow: InfoWindow(title: kampus.nama, snippet: kampus.alamat),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                kampus.nama,
                style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 10)]),
              ),
              background: GoogleMap(
                initialCameraPosition: CameraPosition(target: initialPosition, zoom: 15),
                markers: {kampusMarker},
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailCard(
                    context,
                    title: 'Informasi Umum',
                    children: [
                      _buildDetailRow(context, Icons.school_outlined, 'Kategori', kampus.kategori),
                      _buildDetailRow(context, Icons.star_outline, 'Jurusan Unggulan', kampus.jurusan),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    title: 'Lokasi & Kontak',
                    children: [
                      _buildDetailRow(context, Icons.location_on_outlined, 'Alamat', kampus.alamat),
                      _buildDetailRow(context, Icons.phone_outlined, 'No. Telepon', kampus.noTelp),
                      _buildDetailRow(context, Icons.map_outlined, 'Koordinat', '${kampus.latitude}, ${kampus.longitude}'),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
