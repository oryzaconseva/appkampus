<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Laravel\Lumen\Auth\Authorizable;

class User extends Model implements AuthenticatableContract, AuthorizableContract
{
    use Authenticatable, Authorizable, HasFactory;

    // Properti yang bisa diisi secara massal (mass assignable).
    protected $fillable = [
        'name', 'email', 'password',
    ];

    // Properti yang harus disembunyikan saat diubah menjadi array atau JSON.
    // Sangat penting untuk keamanan!
    protected $hidden = [
        'password', 'api_token',
    ];
}
