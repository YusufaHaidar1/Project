<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Hash;

class StudentData extends Model
{
    use HasFactory;

    protected $table = 'students_data';

    protected $fillable = [
        'nim', 
        'nama', 
        'no_telp', 
        'password'
    ];

    protected $hidden = ['password'];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // A mutator to encrypt the password attribute
    public function setPasswordAttribute($value)
    {
        $this->attributes['password'] = Hash::make($value);
    }
}