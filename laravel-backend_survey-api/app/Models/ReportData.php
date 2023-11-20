<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReportData extends Model
{
    use HasFactory;

    // The table associated with the model
    protected $table = 'reports_data';

    // The attributes that are mass assignable
    protected $fillable = ['nim', 'tipe', 'kronologi', 'evidence'];

    // The attributes that should be cast to native types
    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // A method to get the student data that belongs to this report
    public function student()
    {
        return $this->belongsTo(StudentData::class, 'nim', 'nim');
    }
}