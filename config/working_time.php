<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Office working time
    |--------------------------------------------------------------------------
    |
    | SLA clocks count only these windows. Saturdays and Sundays are skipped
    | automatically; list holiday dates as Y-m-d to skip them too.
    |
    | The same schedule is mirrored in resources/js/utils/workingTime.js for
    | client-side countdowns. Keep both files in sync.
    |
    */
    'timezone' => 'Asia/Manila',

    // ISO weekdays: 1 = Monday ... 7 = Sunday.
    'days' => [1, 2, 3, 4, 5],

    // 8 working hours per day, with a 12:00-13:00 lunch break.
    'windows' => [
        ['08:00', '12:00'],
        ['13:00', '17:00'],
    ],

    // No holidays for now; weekends are always skipped.
    'holidays' => [],
];
