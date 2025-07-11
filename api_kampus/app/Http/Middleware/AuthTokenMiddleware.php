<?php

namespace App\Http\Middleware;

use Closure;
use App\Models\User; // Kita butuh Model User untuk mencari token

class AuthTokenMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        // 1. Periksa apakah request membawa header 'Authorization'
        if (!$request->header('Authorization')) {
            return response()->json(['success' => false, 'message' => 'Authorization header not found.'], 401);
        }

        // 2. Ambil token dari header. Formatnya biasanya "Bearer {token}"
        //    Kita perlu membersihkan "Bearer " untuk mendapatkan tokennya saja.
        $token = str_replace('Bearer ', '', $request->header('Authorization'));

        // 3. Cari user di database yang memiliki api_token yang cocok.
        $user = User::where('api_token', $token)->first();

        // 4. Jika user tidak ditemukan dengan token tersebut...
        if (!$user) {
             return response()->json(['success' => false, 'message' => 'Unauthorized. Invalid token.'], 401);
        }

        // 5. Jika user ditemukan, kita "suntikkan" data user tersebut ke dalam request.
        //    Ini sangat berguna agar di Controller nanti kita tahu siapa user yang sedang login.
        $request->auth = $user;

        // 6. Lanjutkan request ke tujuan berikutnya (Controller).
        return $next($request);
    }
}
