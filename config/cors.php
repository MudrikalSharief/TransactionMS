<?php

return [

    'paths' => [
        'api/*',
        'sanctum/csrf-cookie',
    ],

    'allowed_methods' => ['*'],

    // Same-origin (127.0.0.1:8000) is fine, but keep this permissive for local dev.
    'allowed_origins' => [
        'http://127.0.0.1:8000',
    ],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    // REQUIRED for Sanctum cookie auth
    'supports_credentials' => true,

];
