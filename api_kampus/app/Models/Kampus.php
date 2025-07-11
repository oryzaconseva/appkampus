<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kampus extends Model
{
    /**
     * Beritahu model ini untuk menggunakan tabel bernama 'kampus'.
     *
     * @var string
     */
    protected $table = 'kampus'; // <-- TAMBAHKAN BARIS INI

    /**
     * Properti $fillable untuk mendaftarkan kolom mana saja
     * yang boleh diisi melalui aplikasi kita.
     */
    protected $fillable = [
        'nama_kampus',
        'alamat',
        'no_telpon',
        'kategori',
        'latitude',
        'longitude',
        'jurusan',
    ];
}
