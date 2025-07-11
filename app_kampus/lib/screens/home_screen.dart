// lib/screens/home_screen.dart

import 'package:app_kampus/models/kampus.dart';
import 'package:app_kampus/providers/kampus_provider.dart';
import 'package:app_kampus/screens/add_edit_kampus_screen.dart';
import 'package:app_kampus/screens/detail_kampus_screen.dart';
import 'package:app_kampus/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KampusProvider>(context, listen: false).fetchKampusData();
    });
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _navigateToAddEdit(BuildContext context, {Kampus? kampus}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditKampusScreen(kampus: kampus),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Kampus kampus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data "${kampus.nama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final provider = Provider.of<KampusProvider>(context, listen: false);
              final success = await provider.deleteKampus(kampus.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Data berhasil dihapus' : provider.errorMessage ?? 'Gagal menghapus data'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kampus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Consumer<KampusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.kampusList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.kampusList.isEmpty) {
            return _buildErrorState(context, provider);
          }
          if (provider.kampusList.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchKampusData(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: provider.kampusList.length,
              itemBuilder: (context, index) {
                final kampus = provider.kampusList[index];
                return _buildKampusCard(context, kampus);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(context),
        tooltip: 'Tambah Kampus Baru',
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kampus'),
      ),
    );
  }

  Widget _buildKampusCard(BuildContext context, Kampus kampus) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Text(
            kampus.kategori.substring(0, 1),
            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark),
          ),
        ),
        title: Text(kampus.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            '${kampus.jurusan}\n${kampus.alamat}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.blue.shade600, size: 22), onPressed: () => _navigateToAddEdit(context, kampus: kampus)),
            IconButton(icon: Icon(Icons.delete, color: Colors.red.shade600, size: 22), onPressed: () => _showDeleteDialog(context, kampus)),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailKampusScreen(kampus: kampus))),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, color: Colors.grey.shade400, size: 100),
          const SizedBox(height: 20),
          Text('Belum Ada Data Kampus', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Tekan tombol + untuk menambahkan data pertama Anda.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, KampusProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, color: Colors.red.shade300, size: 80),
            const SizedBox(height: 20),
            Text('Gagal Memuat Data', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(provider.errorMessage!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              onPressed: () => provider.fetchKampusData(),
            )
          ],
        ),
      ),
    );
  }
}
