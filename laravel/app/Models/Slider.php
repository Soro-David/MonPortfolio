<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Slider extends Model
{
    use HasFactory;

    protected $appends = [
        'primary_image',
    ];

    protected $fillable = [
        'title',
        'slogan',
        'subtitle',
        'image1',
        'image2',
        'image3',
        'order',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'order' => 'integer',
    ];

    public function getPrimaryImageAttribute(): ?string
    {
        return $this->image1 ?: $this->image2 ?: $this->image3;
    }
}
