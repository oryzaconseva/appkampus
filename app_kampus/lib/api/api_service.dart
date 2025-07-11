// lib/api/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_kampus/models/kampus.dart'; // Pastikan import model Kampus sudah ada

// ---- KITA TARUH BASEURL LANGSUNG DI SINI ----
const String baseURL = 'http://192.168.1.21:8000/api';

class ApiService {
  // --- FUNGSI REGISTER (Sudah Benar) ---
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // --- FUNGSI LOGIN (Sudah Benar) ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['data']['api_token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_token', data['data']['api_token']);
    }

    return data;
  }

  // ==========================================================
  // --- PENAMBAHAN & PERBAIKAN ADA DI BAWAH INI ---
  // ==========================================================

  // 1. FUNGSI UNTUK MENGAMBIL DAFTAR KAMPUS
  Future<List<Kampus>> getKampusList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('$baseURL/kampus'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Wajib menyertakan token!
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> kampusJson = responseData['data'];
      // Mengubah setiap item JSON di dalam list menjadi objek Kampus
      return kampusJson.map((json) => Kampus.fromJson(json)).toList();
    } else {
      // Jika gagal, berikan pesan error
      throw Exception('Gagal mengambil data kampus dari API');
    }
  }

  // 2. FUNGSI UNTUK LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    if (token == null) {
      return; // Tidak ada token, tidak perlu logout
    }

    // Panggil API logout untuk menghapus token di server
    await http.post(
      Uri.parse('$baseURL/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Hapus token dari penyimpanan lokal di HP
    await prefs.remove('api_token');
  }

  Future<Map<String, dynamic>> addKampus(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    final response = await http.post(
      Uri.parse('$baseURL/kampus'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // FUNGSI UNTUK MENGUBAH KAMPUS (UPDATE)
  Future<Map<String, dynamic>> updateKampus(int id, Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    final response = await http.put(
      Uri.parse('$baseURL/kampus/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // FUNGSI UNTUK MENGHAPUS KAMPUS (DELETE)
  Future<Map<String, dynamic>> deleteKampus(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('api_token');

    final response = await http.delete(
      Uri.parse('$baseURL/kampus/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }
}