<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up() {
        Schema::create('kampus', function (Blueprint $table) {
            $table->id();
            $table->string('nama_kampus');
            $table->text('alamat');
            $table->string('no_telpon');
            $table->enum('kategori', ['Swasta', 'Negeri']);
            $table->double('latitude', 10, 8);
            $table->double('longitude', 11, 8);
            $table->string('jurusan');
            $table->timestamps();
        });
    }
    public function down() {
        Schema::dropIfExists('kampus');
    }
};
