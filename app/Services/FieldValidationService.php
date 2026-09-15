<?php

namespace App\Services;

use App\Models\FieldDefinition;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Validator;

class FieldValidationService
{
    public function validateForStep(array $fieldDefs, array $incomingByCode): array
    {
        $rulesByCode = [];
        $defsByCode = [];

        foreach ($fieldDefs as $def) {
            /** @var FieldDefinition $def */
            $defsByCode[$def->code] = $def;

            $rules = [];

            $isRequired = (bool)($def->pivot?->required_override ?? $def->required);
            $rules[] = $isRequired ? 'required' : 'nullable';

            switch ($def->type) {
                case 'text':
                case 'textarea':
                    $rules[] = 'string';
                    if ($def->min_length !== null) $rules[] = 'min:' . (int)$def->min_length;
                    if ($def->max_length !== null) $rules[] = 'max:' . (int)$def->max_length;
                    break;

                case 'number':
                    $rules[] = 'numeric';
                    if ($def->min_value !== null) $rules[] = 'gte:' . (string)$def->min_value;
                    if ($def->max_value !== null) $rules[] = 'lte:' . (string)$def->max_value;
                    break;

                case 'date':
                    $rules[] = 'date';
                    break;

                case 'boolean':
                    $rules[] = 'boolean';
                    break;

                case 'select':
                    $rules[] = 'string';
                    if (is_array($def->options) && count($def->options)) {
                        $rules[] = 'in:' . implode(',', array_map('strval', $def->options));
                    }
                    break;

                case 'multiselect':
                    $rules[] = 'array';
                    if (is_array($def->options) && count($def->options)) {
                        $rules[] = 'max:' . count($def->options);
                    }
                    break;

                default:
                    $rules[] = 'nullable';
            }

            if (is_array($def->validation_rules)) {
                foreach ($def->validation_rules as $extra) {
                    if (is_string($extra) && $extra !== '') {
                        $rules[] = $extra;
                    }
                }
            }

            $rulesByCode[$def->code] = $rules;
        }

        $v = Validator::make($incomingByCode, $rulesByCode);
        $validatedByCode = $v->validate();

        $normalized = [];
        foreach ($validatedByCode as $code => $value) {
            $def = $defsByCode[$code];

            $valueJson = match ($def->type) {
                'multiselect' => is_array($value) ? array_values($value) : [],
                'number' => $value === null ? null : (float)$value,
                'boolean' => $value === null ? null : (bool)$value,
                default => $value,
            };

            $normalized[$def->id] = [
                'code' => $def->code,
                'value' => $valueJson,
            ];
        }

        return $normalized;
    }

    public function toValueText(mixed $value): ?string
    {
        if ($value === null) return null;
        if (is_scalar($value)) return (string)$value;
        return json_encode($value);
    }
}
