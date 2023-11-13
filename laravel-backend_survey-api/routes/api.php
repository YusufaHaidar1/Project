<?php

use App\Http\Controllers\APIController;
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