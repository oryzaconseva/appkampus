// lib/main.dart

import 'package:app_kampus/providers/auth_provider.dart';
import 'package:app_kampus/providers/kampus_provider.dart';
import 'package:app_kampus/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan palet warna coklat kita
    final Color coklatTua = Colors.brown.shade800;
    final Color coklatSedang = Colors.brown.shade600;
    final Color coklatMuda = Colors.brown.shade50;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => KampusProvider()),
      ],
      child: MaterialApp(
        title: 'App Kampus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // --- TEMA WARNA COKLAT YANG DIPERBARUI ---
          primaryColor: coklatTua,
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: coklatMuda,
          visualDensity: VisualDensity.adaptivePlatformDensity,

          appBarTheme: AppBarTheme(
            backgroundColor: coklatTua, // Coklat tua untuk AppBar
            foregroundColor: Colors.white,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: coklatSedang, // Coklat sedang untuk tombol
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: coklatTua, // Coklat tua untuk FAB
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: coklatSedang, // Warna teks untuk TextButton
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: coklatTua, width: 2), // Border saat di-klik
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
