<?php

// Local development hosts that may call the API with session cookies.
// Laragon exports SANCTUM_STATEFUL_DOMAINS globally, which overrides .env,
// so merge the local aliases here instead of relying on .env alone.
$stateful = array_filter(array_map(
    'trim',
    explode(',', (string) env('SANCTUM_STATEFUL_DOMAINS', '')),
));

if (in_array(env('APP_ENV', 'production'), ['local', 'testing'], true)) {
    $stateful = array_merge($stateful, [
        '127.0.0.1:8000',
        'localhost:8000',
        '127.0.0.1',
        'localhost',
        '[::1]:8000',
        '::1',
    ]);
}

return [

    /*
    |--------------------------------------------------------------------------
    | Stateful Domains
    |--------------------------------------------------------------------------
    |
    | Requests from the following domains / hosts will receive stateful API
    | authentication cookies. Typically, these should include your local
    | and production domains which access your API via a frontend SPA.
    |
    */

    'stateful' => array_values(array_unique($stateful)),

    /*
    |--------------------------------------------------------------------------
    | Sanctum Guards
    |--------------------------------------------------------------------------
    */

    'guard' => ['web'],

    /*
    |--------------------------------------------------------------------------
    | Expiration Minutes
    |--------------------------------------------------------------------------
    */

    'expiration' => null,

    /*
    |--------------------------------------------------------------------------
    | Token Prefix
    |--------------------------------------------------------------------------
    */

    'token_prefix' => env('SANCTUM_TOKEN_PREFIX', ''),

    /*
    |--------------------------------------------------------------------------
    | Sanctum Middleware
    |--------------------------------------------------------------------------
    */

    'middleware' => [
        'authenticate_session' => Laravel\Sanctum\Http\Middleware\AuthenticateSession::class,
        'encrypt_cookies' => Illuminate\Cookie\Middleware\EncryptCookies::class,
        'validate_csrf_token' => Illuminate\Foundation\Http\Middleware\ValidateCsrfToken::class,
    ],

];
