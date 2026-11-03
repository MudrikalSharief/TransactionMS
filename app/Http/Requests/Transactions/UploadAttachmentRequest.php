<?php

namespace App\Http\Requests\Transactions;

use Illuminate\Foundation\Http\FormRequest;

class UploadAttachmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'file' => [
                'required',
                'file',
                'max:20480',
                'mimes:pdf,doc,docx,png,jpg,jpeg,webp,bmp,txt,md,log,csv,xls,xlsx',
                'mimetypes:application/pdf,'
                    . 'application/msword,application/vnd.ms-word,'
                    . 'application/vnd.openxmlformats-officedocument.wordprocessingml.document,'
                    . 'image/png,image/jpeg,image/webp,image/bmp,image/x-ms-bmp,'
                    . 'text/plain,text/markdown,text/x-markdown,text/x-log,'
                    . 'text/csv,application/csv,'
                    . 'application/vnd.ms-excel,application/x-msexcel,'
                    . 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ],
            'requirement_definition_id' => ['nullable', 'integer', 'exists:requirement_definitions,id'],
            'label' => ['nullable', 'string', 'max:120'],
        ];
    }

    public function messages(): array
    {
        return [
            'file.max' => 'File must not exceed 20MB.',
            'file.mimes' => 'Unsupported file type. Upload PDF, Word, image (no GIF), text, or Excel files only.',
            'file.mimetypes' => 'Unsupported file type. Upload PDF, Word, image (no GIF), text, or Excel files only.',
        ];
    }
}
