<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use RuntimeException;

abstract class TestCase extends BaseTestCase
{
    /**
     * Refuse to run tests against the development database. The shell on this
     * machine exports APP_ENV=local and DB_CONNECTION=mysql, and
     * `php artisan test` boots the app before PHPUnit applies phpunit.xml.
     * Without this guard, RefreshDatabase would migrate:fresh the real DB.
     */
    public function createApplication()
    {
        $app = parent::createApplication();

        $connection = config('database.default');
        $database = config("database.connections.{$connection}.database");

        if ($connection !== 'sqlite' || $database !== ':memory:') {
            throw new RuntimeException(
                "Refusing to run tests against [{$connection}:{$database}]. "
                . 'Tests must use sqlite :memory:.'
            );
        }

        return $app;
    }
}
