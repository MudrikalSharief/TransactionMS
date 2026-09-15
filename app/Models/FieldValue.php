<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class FieldValue extends Model
{
    protected $fillable = [
        'transaction_id',
        'field_definition_id',
        'value_text',
        'value_number',
        'value_json',
        'updated_by',
    ];

    protected $casts = [
        'value_number' => 'decimal:2',
        'value_json' => 'array',
    ];

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    public function fieldDefinition(): BelongsTo
    {
        return $this->belongsTo(FieldDefinition::class);
    }

    public function typedValue(): mixed
    {
        $type = $this->fieldDefinition?->type;

        return match ($type) {
            'number', 'currency' => $this->value_number !== null ? (float) $this->value_number : null,
            'select', 'multiselect', 'json' => $this->value_json,
            default => $this->value_text,
        };
    }

    public static function splitValueByType(string $type, mixed $value): array
    {
        if ($value === '' || $value === null) {
            return ['value_text' => null, 'value_number' => null, 'value_json' => null];
        }

        return match ($type) {
            'number', 'currency' => [
                'value_text' => null,
                'value_number' => is_numeric($value) ? $value : null,
                'value_json' => null,
            ],
            'select' => [
                'value_text' => null,
                'value_number' => null,
                'value_json' => [$value],
            ],
            'multiselect' => [
                'value_text' => null,
                'value_number' => null,
                'value_json' => is_array($value) ? array_values($value) : [$value],
            ],
            'json' => [
                'value_text' => null,
                'value_number' => null,
                'value_json' => is_array($value) ? $value : ['value' => $value],
            ],
            default => [
                'value_text' => (string) $value,
                'value_number' => null,
                'value_json' => null,
            ],
        };
    }
}
