<?php

namespace App\Http\Controllers;

use App\Models\User;           // Import model User
use Illuminate\Http\Request;    // Import class Request untuk menangani data yang masuk
use Illuminate\Support\Facades\Hash; // Import class Hash untuk enkripsi password
use Illuminate\Support\Str;      // Import class Str untuk membuat string acak

class AuthController extends Controller
{
    /**
     * Fungsi untuk registrasi user baru.
     */
    public function register(Request $request)
    {
        // Validasi adalah garda terdepan keamanan.
        // Ini memastikan data yang masuk sesuai format yang kita inginkan.
        $this->validate($request, [
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email', // email harus unik di tabel users
            'password' => 'required|string|min:6', // password minimal 6 karakter
        ]);

        // Jika validasi lolos, buat user baru menggunakan Model User.
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password), // PENTING: Password WAJIB di-hash!
        ]);

        // Beri response dalam format JSON yang menandakan sukses.
        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil!',
            'data' => $user
        ], 201); // 201 artinya "Created" / Berhasil Dibuat
    }

    /**
     * Fungsi untuk login user.
     */
    public function login(Request $request)
    {
        // Validasi data login
        $this->validate($request, [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        // Cari user di database berdasarkan email yang diinput.
        $user = User::where('email', $request->email)->first();

        // Cek: jika user tidak ada ATAU password yang diinput tidak cocok dengan hash di DB.
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah.',
            ], 401); // 401 artinya "Unauthorized" / Tidak Punya Akses
        }

        // Jika email dan password cocok, buatkan token acak.
        $token = Str::random(60);

        // Simpan token tersebut ke kolom api_token milik user di database.
        $user->api_token = $token;
        $user->save();

        // Kembalikan response sukses beserta tokennya.
        // Token inilah yang akan disimpan oleh Flutter.
        return response()->json([
            'success' => true,
            'message' => 'Login berhasil!',
            'data' => [
                'user' => $user->makeHidden('api_token'), // Kirim data user, tapi tetap sembunyikan token
                'api_token' => $token,
            ]
        ]);
    }

    /**
     * Fungsi untuk logout user.
     * Catatan: Fungsi ini memerlukan middleware untuk bekerja,
     * yang akan kita buat setelah mengatur Rute (Routes).
     */
    public function logout(Request $request)
    {
        // $request->auth akan berisi data user yang sedang login.
        // Ini akan di-inject oleh middleware kita nanti.
        $user = $request->auth;

        if ($user) {
            // Hapus token dari database dengan mengisinya menjadi null.
            $user->api_token = null;
            $user->save();

            return response()->json([
                'success' => true,
                'message' => 'Logout berhasil!',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'User tidak ditemukan.',
        ], 404);
    }
}
