<?php

namespace App\Http\Controllers;

use App\Models\Area;
use App\Models\DistributionBox;
use Illuminate\Http\Request;

class DistributionBoxController extends Controller
{
    /**
     * Display a listing of the resource (API).
     */
    public function index()
    {
        // 'area' রিলেশনশিপসহ ডেটা আনা হচ্ছে যাতে ফ্রন্টএন্ডে এরিয়ার নাম দেখানো যায়
        $distributionBoxes = DistributionBox::with('area')->orderBy('id', 'desc')->paginate(10); 
        return response()->json($distributionBoxes, 200);
    }

    /**
     * Store a newly created resource in storage (API).
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'box_code' => 'required|string|max:50|unique:distribution_boxes,box_code',
            'name'     => 'nullable|string|max:150',
            'area_id'  => 'required|exists:areas,id', 
        ]);
        
        $box = DistributionBox::create($validated);

        return response()->json([
            'message' => 'Distribution Box created successfully.',
            'data'    => $box->load('area') // নতুন বক্সের সাথে এরিয়া ইনফোও ফেরত পাঠানো
        ], 201);
    }

    /**
     * Display the specified resource (API).
     */
    public function show(DistributionBox $distributionBox)
    {
        return response()->json($distributionBox->load('area'), 200);
    }

    /**
     * Update the specified resource in storage (API).
     */
    public function update(Request $request, DistributionBox $distributionBox)
    {
        $validated = $request->validate([
            'box_code' => 'required|string|max:50|unique:distribution_boxes,box_code,' . $distributionBox->id,
            'name'     => 'nullable|string|max:150',
            'area_id'  => 'required|exists:areas,id',
        ]);

        $distributionBox->update($validated);

        return response()->json([
            'message' => 'Distribution Box updated successfully.',
            'data'    => $distributionBox->load('area')
        ], 200);
    }

    /**
     * Remove the specified resource from storage (API).
     */
    public function destroy(DistributionBox $distributionBox)
    {
        $distributionBox->delete();
        
        return response()->json([
            'message' => 'Distribution Box deleted successfully.'
        ], 200);
    }
}