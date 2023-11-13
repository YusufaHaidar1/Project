<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\StudentComplaintSurvey;
use Illuminate\Support\Facades\DB;

class APIController extends Controller
{
    public function index()
    {
        // Detail hasil survey semua responden
        $data = StudentComplaintSurvey::all();
        return $data;
    }
    public function showCount()
    {
        // Detail hasil survey semua responden
        $data = StudentComplaintSurvey::all()->count();
        return $data;
    }
    public function showRange(Request $request)
    {
        // Detail hasil survey semua responden
        $data = StudentComplaintSurvey::offset($request->offset)->limit($request->limit)->get();
        return $data;
    }

    public function show(Request $request)
    {
        // Detail hasil survey per responden
        $data = StudentComplaintSurvey::all()->where('id',$request->id)->first();
        return $data;
    }
    // Jumlah faktor yang dipermasalahkan (per faktor)
    public function showByFactor()
    {
        $data = StudentComplaintSurvey::groupBy('genre')
            ->select('genre', DB::raw('count(*) as total'))->get();
        return $data;
    }
    // Jumlah responden berdasarkan gender
    public function showByGender()
    {
        $data = StudentComplaintSurvey::groupBy('gender')
            ->select('gender', DB::raw('count(*) as total'))->get();
        return $data;
    }
    // Jumlah responden berdasarkan negara asal
    public function showByNationality()
    {
        $data = StudentComplaintSurvey::groupBy('nationality')
            ->select('nationality', DB::raw('count(*) as total'))->get();
        return $data;
    }

    // Rata-rata umur responden total
    public function getAvgAge()
    {
        $data = StudentComplaintSurvey::avg('age');
        return $data;
    }
    // Rata-rata IPK (GPA) responden tota
    public function getAvgGPA()
    {
        $data = StudentComplaintSurvey::avg('gpa');
        return $data;
    }
    public function insertData(Request $request)
    {
        //
        $save = new StudentComplaintSurvey;
        $save->genre = $request->genre;
        $save->reports = $request->reports;
        $save->age = $request->age;
        $save->gpa = $request->gpa;
        $save->year = $request->year;
        $save->count = $request->count;
        $save->gender = $request->gender;
        $save->nationality = $request->nationality;
        $save->save();

        return "Berhasil menyimpan data!!";
    }
}
