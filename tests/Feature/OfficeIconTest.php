<?php

namespace Tests\Feature;

use App\Models\Office;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OfficeIconTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        Storage::fake('public');

        $user = User::factory()->create();
        $user->roles()->attach(
            Role::firstOrCreate(['code' => 'superadmin'], ['name' => 'Superadmin'])->id
        );

        Sanctum::actingAs($user);
    }

    public function test_office_can_be_created_with_an_uploaded_icon(): void
    {
        $response = $this->post('/api/admin/offices', [
            'code' => 'TEST_ICON',
            'name' => 'Test Icon Office',
            'description' => 'Office with a custom icon.',
            'icon' => UploadedFile::fake()->image('office-icon.png', 64, 64),
        ], ['Accept' => 'application/json']);

        $response->assertCreated()
            ->assertJsonPath('data.code', 'TEST_ICON');

        $office = Office::query()->where('code', 'TEST_ICON')->firstOrFail();

        $this->assertNotNull($office->icon_path);
        $this->assertStringContainsString($office->icon_path, $response->json('data.icon_url'));
        Storage::disk('public')->assertExists($office->icon_path);
    }

    public function test_office_icon_can_be_replaced_and_removed(): void
    {
        $office = Office::create([
            'code' => 'TEST_ICON',
            'name' => 'Test Icon Office',
        ]);

        $this->post("/api/admin/offices/{$office->id}", [
            '_method' => 'PUT',
            'code' => $office->code,
            'name' => $office->name,
            'icon' => UploadedFile::fake()->image('first.png', 64, 64),
        ], ['Accept' => 'application/json'])->assertOk();

        $office->refresh();
        $firstPath = $office->icon_path;
        $this->assertNotNull($firstPath);
        Storage::disk('public')->assertExists($firstPath);

        $this->post("/api/admin/offices/{$office->id}", [
            '_method' => 'PUT',
            'code' => $office->code,
            'name' => $office->name,
            'icon' => UploadedFile::fake()->image('second.webp', 64, 64),
        ], ['Accept' => 'application/json'])->assertOk();

        $office->refresh();
        $secondPath = $office->icon_path;
        $this->assertNotSame($firstPath, $secondPath);
        Storage::disk('public')->assertMissing($firstPath);
        Storage::disk('public')->assertExists($secondPath);

        $this->post("/api/admin/offices/{$office->id}", [
            '_method' => 'PUT',
            'code' => $office->code,
            'name' => $office->name,
            'remove_icon' => '1',
        ], ['Accept' => 'application/json'])
            ->assertOk()
            ->assertJsonPath('data.icon_url', null);

        $office->refresh();
        $this->assertNull($office->icon_path);
        Storage::disk('public')->assertMissing($secondPath);
    }

    public function test_office_icon_must_be_an_allowed_image(): void
    {
        $this->post('/api/admin/offices', [
            'code' => 'TEST_ICON',
            'name' => 'Test Icon Office',
            'icon' => UploadedFile::fake()->create('notes.txt', 10, 'text/plain'),
        ], ['Accept' => 'application/json'])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('icon');

        $this->assertDatabaseMissing('offices', ['code' => 'TEST_ICON']);
    }
}
