<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\StudentComplaintSurvey;

class StudentComplaintSurveySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        StudentComplaintSurvey::truncate();
        
        $csvFile = fopen(base_path("database/data/StudentComplaintSurvey.csv"), "r");
  
        $firstline = true;
        while (($data = fgetcsv($csvFile, 1500, ",")) !== FALSE) {
            if (!$firstline) {
                StudentComplaintSurvey::create([
                    'genre' => $data['0'],
                    'reports' => $data['1'],
                    'age' => $data['2'],
                    'gpa' => $data['3'],
                    'year' => $data['4'],
                    'count' => $data['5'],
                    'gender' => $data['6'],
                    'nationality' => $data['7'],
                ]);    
            }
            $firstline = false;
        }
   
        fclose($csvFile);
    }
}
