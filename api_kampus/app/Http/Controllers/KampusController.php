<?php

namespace App\Http\Controllers;

use App\Models\Kampus; // Import model Kampus
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth; // Kita butuh ini untuk tahu siapa yang input data

class KampusController extends Controller
{
    /**
     * READ ALL: Menampilkan semua data kampus.
     */
    public function index()
    {
        // Ambil semua data dari model Kampus, urutkan dari yang terbaru.
        $kampus = Kampus::orderBy('created_at', 'DESC')->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar semua kampus',
            'data' => $kampus
        ]);
    }

    /**
     * CREATE: Menyimpan data kampus baru.
     */
    public function store(Request $request)
    {
        // Validasi data yang masuk
        $this->validate($request, [
            'nama_kampus' => 'required|string',
            'alamat' => 'required|string',
            'no_telpon' => 'required|string',
            'kategori' => 'required|in:Swasta,Negeri', // Hanya boleh Swasta atau Negeri
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'jurusan' => 'required|string',
        ]);

        // Buat data kampus baru menggunakan data dari request
        $kampus = Kampus::create($request->all());

        if ($kampus) {
            return response()->json([
                'success' => true,
                'message' => 'Kampus berhasil ditambahkan',
                'data' => $kampus
            ], 201);
        }

        return response()->json(['success' => false, 'message' => 'Gagal menambahkan kampus'], 500);
    }

    /**
     * READ ONE: Menampilkan satu data kampus berdasarkan ID.
     */
    public function show($id)
    {
        $kampus = Kampus::find($id);

        if (!$kampus) {
            return response()->json(['success' => false, 'message' => 'Kampus tidak ditemukan'], 404);
        }

        return response()->json(['success' => true, 'data' => $kampus]);
    }

    /**
     * UPDATE: Mengubah data kampus yang sudah ada.
     */
    public function update(Request $request, $id)
    {
        $kampus = Kampus::find($id);

        if (!$kampus) {
            return response()->json(['success' => false, 'message' => 'Kampus tidak ditemukan'], 404);
        }

        // Validasi data lagi untuk update
        $this->validate($request, [
            'nama_kampus' => 'required|string',
            'alamat' => 'required|string',
            'no_telpon' => 'required|string',
            'kategori' => 'required|in:Swasta,Negeri',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'jurusan' => 'required|string',
        ]);

        $kampus->update($request->all());

        return response()->json(['success' => true, 'message' => 'Kampus berhasil diupdate', 'data' => $kampus]);
    }

    /**
     * DELETE: Menghapus data kampus.
     */
    public function destroy($id)
    {
        $kampus = Kampus::find($id);

        if (!$kampus) {
            return response()->json(['success' => false, 'message' => 'Kampus tidak ditemukan'], 404);
        }

        $kampus->delete();

        return response()->json(['success' => true, 'message' => 'Kampus berhasil dihapus']);
    }
}
