<?php

namespace App\Http\Controllers;

use App\Models\ReportData;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class ReportsAPIController extends Controller
{
    // All report data
    public function index()
    {
        $reports = ReportData::with('student')->latest()->get();
        return response()->json($reports, 200);
    }

    // range report data
    public function showRange(Request $request)
    {
        $request->validate([
            'limit' => 'required|integer|min:10',
            'offset' => 'required|integer|min:0',
        ]);

        // Get the limit and offset values from the request
        $limit = $request->input('limit');
        $offset = $request->input('offset');

        // Use the with method to eager load the student relation
        // Use the skip and take methods to apply the limit and offset
        $reports = ReportData::with('student')->skip($offset)->take($limit)->latest()->get();
        // Return the data as a json response
        return response()->json($reports, 200);
    }

    // Single report data by id
    public function show($id)
    {
        $report = ReportData::with('student')->find($id);
        if ($report) {
            return response()->json($report, 200);
        } else {
            return response()->json(['message' => 'Report tidak ditemukan'], 404);
        }
    }

    // Gambar report by id
    public function showimg($id)
    {
        $report = ReportData::find($id);
        if ($report && $report->evidence) {
            $path = $report->evidence;
            $file = Storage::get($path);
            $type = Storage::mimeType($path);
            return response($file, 200)->header('Content-Type', $type);
        } else {
            return response()->json(['message' => 'Gambar tidak ditemukan'], 404);
        }
    }

    // Add report data
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nim' => 'required|exists:students_data,nim',
            'tipe' => 'required',
            'kronologi' => 'required',
            'evidence' => 'sometimes|image',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $report = new ReportData();
        $report->nim = $request->nim;
        $report->tipe = $request->tipe;
        $report->kronologi = $request->kronologi;
        if ($request->hasFile('evidence')) {
            $file = $request->file('evidence');
            $id = ReportData::latest()->first()->id ?? 0;
            $id = $id + 1;
            $name = $file->getClientOriginalName();
            $extension = $file->getClientOriginalExtension();
            $filename = $id . $name . '.' . $extension;
            $path = $file->storeAs('public/evidence', $filename);
            $report->evidence = $path;
        }
        $report->save();
        return response()->json(['message' => 'Data berhasil dibuat', 'data' => $report], 201);
    }

    // Update report data by id
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nim' => 'required|exists:students_data,nim',
            'tipe' => 'sometimes',
            'kronologi' => 'sometimes',
            'evidence' => 'sometimes|image',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $report = ReportData::find($id);
        if ($report) {
            $report->nim = $request->nim ?? $report->nim;
            $report->tipe = $request->tipe ?? $report->tipe;
            $report->kronologi = $request->kronologi ?? $report->kronologi;
            if ($request->hasFile('evidence')) {
                $file = $request->file('evidence');
                $id = $report->id;
                $name = $file->getClientOriginalName();
                $extension = $file->getClientOriginalExtension();
                $filename = $id . $name . '.' . $extension;
                Storage::delete($report->evidence);
                $path = $file->storeAs('public/evidence', $filename);
                $report->evidence = $path;
            }
            $report->save();
            return response()->json(['message' => 'Data berhasil diubah', 'data' => $report], 200);
        } else {
            return response()->json(['message' => 'Report tidak ditemukan'], 404);
        }
    }

    // Delete report data by id
    // public function destroy($id)
    // {
    //     $report = ReportData::find($id);
    //     if ($report) {
    //         Storage::delete($report->evidence);
    //         $report->delete();
    //         return response()->json(['message' => 'Report deleted successfully'], 200);
    //     } else {
    //         return response()->json(['message' => 'Report not found'], 404);
    //     }
    // }
}