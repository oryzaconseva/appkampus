<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return 'Selamat Datang di API Data Kampus - ' . $router->app->version();
});

// Membuat grup route dengan prefix 'api'
// Semua rute di dalam grup ini akan memiliki awalan /api
// Contoh: /api/register, /api/login
$router->group(['prefix' => 'api'], function () use ($router) {

    // Rute untuk otentikasi (tidak perlu login untuk akses)
    $router->post('/register', 'AuthController@register');
    $router->post('/login', 'AuthController@login');

});

// Grup BARU untuk rute yang memerlukan otentikasi (WAJIB LOGIN)
$router->group(['prefix' => 'api', 'middleware' => 'auth'], function () use ($router) {
    // Rute logout sekarang kita pindah ke sini agar aman
    $router->post('/logout', 'AuthController@logout');
});

// Grup BARU untuk rute yang memerlukan otentikasi (WAJIB LOGIN)
$router->group(['prefix' => 'api', 'middleware' => 'auth'], function () use ($router) {
    // Rute logout
    $router->post('/logout', 'AuthController@logout');

    // ---- TAMBAHKAN RUTE CRUD KAMPUS DI SINI ----

    // Rute untuk menampilkan semua kampus (Read All)
    $router->get('/kampus', 'KampusController@index');

    // Rute untuk menambah kampus baru (Create)
    $router->post('/kampus', 'KampusController@store');

    // Rute untuk menampilkan detail satu kampus (Read One)
    $router->get('/kampus/{id}', 'KampusController@show');

    // Rute untuk mengubah data kampus (Update)
    $router->put('/kampus/{id}', 'KampusController@update');

    // Rute untuk menghapus kampus (Delete)
    $router->delete('/kampus/{id}', 'KampusController@destroy');
});
