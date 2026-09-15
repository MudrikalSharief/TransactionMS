<?php

namespace App\Services;

class JsonLogicEvaluator
{
    public function evaluate($expr, array $context): bool
    {
        if ($expr === null || $expr === '' || $expr === []) return true;

        if (is_string($expr)) {
            $decoded = json_decode($expr, true);
            if (json_last_error() !== JSON_ERROR_NONE) {
                return false;
            }
            $expr = $decoded;
        }

        $result = $this->apply($expr, $context);

        return (bool) $result;
    }

    private function apply($expr, array $context)
    {
        if (is_null($expr) || is_bool($expr) || is_int($expr) || is_float($expr) || is_string($expr)) {
            return $expr;
        }

        if (is_array($expr) && array_is_list($expr)) {
            return array_map(fn($v) => $this->apply($v, $context), $expr);
        }

        if (!is_array($expr) || count($expr) !== 1) {
            return false;
        }

        $op = array_key_first($expr);
        $args = $expr[$op];

        switch ($op) {
            case 'var':
                return $this->readVar($args, $context);

            case '==':
            case '!=':
            case '>':
            case '>=':
            case '<':
            case '<=':
                $a = $this->apply($args[0] ?? null, $context);
                $b = $this->apply($args[1] ?? null, $context);
                return $this->compare($op, $a, $b);

            case 'and':
                foreach (($args ?? []) as $a) {
                    if (!$this->truthy($this->apply($a, $context))) return false;
                }
                return true;

            case 'or':
                foreach (($args ?? []) as $a) {
                    if ($this->truthy($this->apply($a, $context))) return true;
                }
                return false;

            case '!':
                return !$this->truthy($this->apply($args[0] ?? null, $context));

            case 'missing':
                $fields = is_array($args) ? $args : [];
                $missing = [];
                foreach ($fields as $f) {
                    if (!is_string($f)) continue;
                    $val = $this->getByPath($context, $f);
                    if ($val === null || $val === '') $missing[] = $f;
                }
                return $missing;

            case 'missing_some':
                $min = (int)($args[0] ?? 0);
                $fields = $args[1] ?? [];
                if (!is_array($fields)) return $fields;

                $present = 0;
                $missing = [];
                foreach ($fields as $f) {
                    if (!is_string($f)) continue;
                    $val = $this->getByPath($context, $f);
                    if ($val === null || $val === '') $missing[] = $f;
                    else $present++;
                }
                return ($present >= $min) ? [] : $missing;

            default:
                return false;
        }
    }

    private function readVar($args, array $context)
    {
        if (is_string($args)) {
            return $this->getByPath($context, $args);
        }

        if (is_array($args)) {
            $key = $args[0] ?? null;
            $default = $args[1] ?? null;
            if (!is_string($key)) return $default;

            $val = $this->getByPath($context, $key);
            return ($val === null) ? $default : $val;
        }

        return null;
    }

    private function getByPath(array $context, string $path)
    {
        if ($path === '') return null;

        $parts = explode('.', $path);
        $cur = $context;

        foreach ($parts as $p) {
            if (!is_array($cur) || !array_key_exists($p, $cur)) return null;
            $cur = $cur[$p];
        }

        return $cur;
    }

    private function compare(string $op, $a, $b): bool
    {
        $aNum = is_numeric($a);
        $bNum = is_numeric($b);
        if ($aNum && $bNum) {
            $a = $a + 0;
            $b = $b + 0;
        }

        return match ($op) {
            '==' => $a == $b,
            '!=' => $a != $b,
            '>'  => $a > $b,
            '>=' => $a >= $b,
            '<'  => $a < $b,
            '<=' => $a <= $b,
            default => false,
        };
    }

    private function truthy($v): bool
    {
        return (bool) $v;
    }
}
