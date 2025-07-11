// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:app_kampus/api/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _apiService.login(email, password);

      // Print response dari server untuk debugging
      print('Login Response: $response');

      if (response['success'] == true && response['data']['api_token'] != null) {
        _setLoading(false);
        return true; // Login berhasil
      } else {
        _setErrorMessage(response['message'] ?? 'Login Gagal karena response tidak sesuai');
        _setLoading(false);
        return false; // Login gagal
      }
    } catch (e) {
      _setErrorMessage('Terjadi kesalahan koneksi: ${e.toString()}');
      print('Login Error: $e'); // Print error ke konsol
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _apiService.register(name, email, password);
      print('Register Response: $response'); // Debugging

      if (response['success'] == true) {
        _setLoading(false);
        return true; // Registrasi berhasil
      } else {
        // Coba ambil pesan error lebih detail dari response
        String errorMsg = 'Registrasi Gagal';
        if (response['data'] != null && response['data'] is Map) {
          var errors = response['data'].entries.map((e) => e.value[0]).join('\n');
          errorMsg = errors;
        }
        _setErrorMessage(errorMsg);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('Terjadi kesalahan koneksi: ${e.toString()}');
      print('Register Error: $e'); // Debugging
      _setLoading(false);
      return false;
    }
  }
}