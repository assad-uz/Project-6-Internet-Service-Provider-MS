<?php

namespace App\Http\Controllers;

use App\Models\Package;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class PackageController extends Controller
{
    /**
     * Display a listing of the resource (API).
     */
    public function index()
    {
        // নতুন প্যাকেজগুলো উপরে দেখানোর জন্য 'desc' ব্যবহার করা ভালো, তবে আপনার চাহিদা অনুযায়ী 'asc' রাখতে পারেন।
        $packages = Package::orderBy('id', 'desc')->paginate(10);
        
        return response()->json($packages, 200);
    }

    /**
     * Store a newly created resource in storage (API).
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'package_code' => 'required|string|max:10|unique:packages,package_code',
            'package_name' => 'required|string|max:100',
            'speed'        => 'required|string|max:50',
            'price'        => 'required|numeric|min:0',
        ]);

        $package = Package::create($validatedData);

        return response()->json([
            'message' => 'Package created successfully.',
            'data'    => $package
        ], 201);
    }

    /**
     * Display the specified resource (API).
     */
    public function show(Package $package)
    {
        return response()->json($package, 200);
    }

    /**
     * Update the specified resource in storage (API).
     */
    public function update(Request $request, Package $package)
    {
        $validatedData = $request->validate([
            'package_code' => ['required', 'string', 'max:10', Rule::unique('packages')->ignore($package->id)],
            'package_name' => 'required|string|max:100',
            'speed'        => 'required|string|max:50',
            'price'        => 'required|numeric|min:0',
        ]);

        $package->update($validatedData);

        return response()->json([
            'message' => 'Package updated successfully.',
            'data'    => $package
        ], 200);
    }

    /**
     * Remove the specified resource from storage (API).
     */
    public function destroy(Package $package)
    {
        $package->delete();

        return response()->json([
            'message' => 'Package deleted successfully.'
        ], 200);
    }
}