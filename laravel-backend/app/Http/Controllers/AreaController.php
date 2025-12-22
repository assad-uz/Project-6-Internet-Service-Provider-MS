<?php

namespace App\Http\Controllers;

use App\Models\Area;
use Illuminate\Http\Request;

class AreaController extends Controller
{
    // 1. INDEX: সমস্ত এরিয়া JSON আকারে পাঠানোর জন্য
    public function index()
    {
        // ডাটাবেস থেকে ডাটা আনা হচ্ছে
        $areas = Area::orderBy('id', 'desc')->paginate(10);
        
        // ভিউ এর বদলে JSON রিটার্ন করা হচ্ছে
        return response()->json($areas, 200); 
    }

    // API-তে CREATE এবং EDIT মেথড প্রয়োজন নেই
    // কারণ ফর্মগুলো আপনার Vue প্রোজেক্টে থাকবে।

    // 2. STORE: নতুন ডেটা সেভ করার জন্য
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100|unique:areas,name',
        ]);

        $area = Area::create($validated);

        // রিডাইরেক্ট না করে ডাটা এবং সাকসেস মেসেজ পাঠানো হচ্ছে
        return response()->json([
            'message' => 'Area created successfully.',
            'data' => $area
        ], 201); // 201 মানে নতুন কিছু তৈরি হয়েছে (Created)
    }

    // 3. SHOW: নির্দিষ্ট একটি এরিয়ার ডাটা দেখার জন্য (এটি Vue-তে লাগতে পারে)
    public function show(Area $area)
    {
        return response()->json($area, 200);
    }

    // 4. UPDATE: ডেটা আপডেট করার জন্য
    public function update(Request $request, Area $area)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100|unique:areas,name,' . $area->id,
        ]);

        $area->update($validated);

        return response()->json([
            'message' => 'Area updated successfully.',
            'data' => $area
        ], 200);
    }

    // 5. DESTROY: ডেটা ডিলিট করার জন্য
    public function destroy(Area $area)
    {
        $area->delete();

        return response()->json([
            'message' => 'Area deleted successfully.'
        ], 200);
    }
}