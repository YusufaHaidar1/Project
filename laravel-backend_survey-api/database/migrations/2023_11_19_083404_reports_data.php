<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class ReportsData extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('reports_data', function (Blueprint $table) {
            $table->id();
            $table->string('nim');
            $table->string('tipe');
            $table->longText('kronologi');
            $table->string('evidence')->nullable();
            $table->timestamps();
            $table->foreign('nim')->references('nim')->on('students_data')->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('reports_data');
    }
}
