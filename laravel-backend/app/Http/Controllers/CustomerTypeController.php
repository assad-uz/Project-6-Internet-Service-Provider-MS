<?php

namespace App\Http\Controllers;

use App\Models\CustomerType;
use Illuminate\Http\Request;

class CustomerTypeController extends Controller
{
    // 1. INDEX: সমস্ত কাস্টমার টাইপ JSON আকারে পাঠানোর জন্য
    public function index()
    {
        // প্যাগিনেশন সহ ডেটা নেওয়া হচ্ছে (Vue-তে প্যাগিনেশন হ্যান্ডেল করা সহজ হবে)
        $customerTypes = CustomerType::orderBy('id', 'desc')->paginate(10); 
        
        return response()->json($customerTypes, 200);
    }

    // API-তে create() এবং edit() মেথড লাগে না কারণ ফর্ম থাকে Vue-তে।

    // 2. STORE: নতুন ডেটা সেভ করার জন্য
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:50|unique:customer_types,name',
        ]);
        
        $customerType = CustomerType::create($validated);

        return response()->json([
            'message' => 'Customer Type created successfully.',
            'data' => $customerType
        ], 201); // 201: Created
    }

    // 3. SHOW: নির্দিষ্ট একটি টাইপ দেখার জন্য (Vue Edit পেজে এটি কাজে লাগবে)
    public function show(CustomerType $customerType)
    {
        return response()->json($customerType, 200);
    }

    // 4. UPDATE: ডেটা আপডেট করার জন্য
    public function update(Request $request, CustomerType $customerType)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:50|unique:customer_types,name,' . $customerType->id,
        ]);

        $customerType->update($validated);

        return response()->json([
            'message' => 'Customer Type updated successfully.',
            'data' => $customerType
        ], 200);
    }

    // 5. DESTROY: ডেটা ডিলিট করার জন্য
    public function destroy(CustomerType $customerType)
    {
        $customerType->delete();
        
        return response()->json([
            'message' => 'Customer Type deleted successfully.'
        ], 200);
    }
}