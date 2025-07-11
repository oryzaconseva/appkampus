// lib/providers/kampus_provider.dart

import 'package:flutter/material.dart';
import 'package:app_kampus/api/api_service.dart';
import 'package:app_kampus/models/kampus.dart';

class KampusProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State untuk daftar kampus
  List<Kampus> _kampusList = [];
  List<Kampus> get kampusList => _kampusList;

  // State untuk status loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // State untuk menyimpan pesan error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Mengambil daftar data kampus dari server.
  Future<void> fetchKampusData() async {
    _isLoading = true;
    _errorMessage = null; // Hapus pesan error lama
    notifyListeners();

    try {
      _kampusList = await _apiService.getKampusList();
    } catch (e) {
      _errorMessage = 'Gagal mengambil data: ${e.toString()}';
      _kampusList = []; // Pastikan list kosong jika terjadi error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambahkan data kampus baru ke server.
  /// Mengembalikan `true` jika berhasil, `false` jika gagal.
  Future<bool> addKampus(Map<String, String> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.addKampus(data);
      if (response['success'] == true) {
        // Panggil fetchKampusData untuk sinkronisasi data terbaru.
        // fetchKampusData akan menangani state loading & notifyListeners.
        await fetchKampusData();
        return true;
      } else {
        // Jika API mengembalikan success: false
        _errorMessage = response['message'] ?? 'Gagal menambahkan data.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mengubah data kampus yang ada di server.
  /// Mengembalikan `true` jika berhasil, `false` jika gagal.
  Future<bool> updateKampus(int id, Map<String, String> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updateKampus(id, data);
      if (response['success'] == true) {
        // Panggil fetch untuk data terbaru.
        await fetchKampusData();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal mengubah data.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Menghapus data kampus dari server.
  /// Mengembalikan `true` jika berhasil, `false` jika gagal.
  Future<bool> deleteKampus(int id) async {
    // Untuk delete, kita bisa set loading tanpa menutupi seluruh layar
    // Tapi untuk konsistensi, kita set _isLoading
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteKampus(id);
      if (response['success'] == true) {
        // Hapus item dari list lokal agar UI langsung update (Optimistic UI)
        _kampusList.removeWhere((kampus) => kampus.id == id);
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal menghapus data.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi error: ${e.toString()}';
      return false;
    } finally {
      // Pastikan loading indicator selalu berhenti
      _isLoading = false;
      notifyListeners();
    }
  }
}