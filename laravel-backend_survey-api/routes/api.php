<?php

use App\Http\Controllers\APIController;
use App\Http\Controllers\StudentsAPIController;
use App\Http\Controllers\ReportsAPIController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get("all_data",[APIController::class,"index"]);
Route::get("count_data",[APIController::class,"showCount"]);
Route::get("range_data",[APIController::class,"showRange"]);
Route::get("show_data",[APIController::class,"show"]);
Route::get("show_data/by_factor",[APIController::class,"showByFactor"]);
Route::get("show_data/by_gender",[APIController::class,"showByGender"]);
Route::get("show_data/by_nationality",[APIController::class,"showByNationality"]);
Route::get("get_average_age",[APIController::class,"getAvgAge"]);
Route::get("get_average_gpa",[APIController::class,"getAvgGPA"]);
Route::post("insert_data",[APIController::class,"insertData"]);

Route::get("students", [StudentsAPIController::class, "index"]);
Route::get("students/{nim}", [StudentsAPIController::class, "show"]);
Route::post("students/login", [StudentsAPIController::class, "login"]);
Route::post("add_student", [StudentsAPIController::class, "store"]);
Route::post("edit_student/{nim}", [StudentsAPIController::class, "update"]);

Route::get("reports", [ReportsAPIController::class, "index"]);
Route::get("reports/{id}", [ReportsAPIController::class, "show"]);
Route::get("reports/{id}/image", [ReportsAPIController::class, "showimg"]);
Route::post("add_report", [ReportsAPIController::class, "store"]);
Route::post("edit_report/{id}", [ReportsAPIController::class, "update"]);