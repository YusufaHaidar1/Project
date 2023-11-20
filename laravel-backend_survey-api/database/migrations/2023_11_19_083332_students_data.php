<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class StudentsData extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema :: create('students_data', function (Blueprint $table){
            $table -> id();
            $table -> string('nim')->unique();;
            $table -> string('nama');
            $table -> string('no_telp');
            $table -> string('password');
            $table -> timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema :: dropIfExists('students_data');
    }
}
