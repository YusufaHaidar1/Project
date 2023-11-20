<?php

namespace Database\Seeders;

use App\Models\StudentData;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;


class StudentsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Schema::disableForeignKeyConstraints();
        StudentData::truncate();
        
        // Create some dummy data for testing
        StudentData::create([
            'nim' => '2141762102',
            'nama' => 'Achmad Chaidar Ismail',
            'no_telp' => '081359248338',
            'password' => '2141762102',
        ]);
        StudentData::create([
            'nim' => '2141762069',
            'nama' => 'Angelina Balqis Khansa',
            'no_telp' => '085710571274',
            'password' => '2141762069',
        ]);
        StudentData::create([
            'nim' => '2141762046',
            'nama' => 'Sabila Nadia Islamia',
            'no_telp' => '085852057967',
            'password' => '2141762046',
        ]);
        StudentData::create([
            'nim' => '2141762038',
            'nama' => 'Yusufa Haidar',
            'no_telp' => '085850672915',
            'password' => '2141762038',
        ]);
        Schema::enableForeignKeyConstraints();
    }
}