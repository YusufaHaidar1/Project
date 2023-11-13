<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateStudentComplaintSurveysTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('student_complaint_surveys', function (Blueprint $table) {
            $table->id();
            $table->string('genre');
            $table->longText('reports');
            $table->integer('age');
            $table->float('gpa');
            $table->integer('year');
            $table->integer('count');
            $table->string('gender');
            $table->string('nationality');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('student_complaint_surveys');
    }
}
