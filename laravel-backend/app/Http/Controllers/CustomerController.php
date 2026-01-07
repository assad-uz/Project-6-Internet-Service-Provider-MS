<?php

namespace App\Http\Controllers;

use App\Models\Area;
use App\Models\Customer;
use App\Models\CustomerType;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CustomerController extends Controller
{
    // ১. INDEX: কাস্টমার লিস্ট (API)
    public function index()
    {
        $customers = Customer::with(['area', 'customerType'])
                             ->orderBy('id', 'desc')
                             ->paginate(10); 
                             
        return response()->json([
            'success' => true,
            'data' => $customers
        ]);
    }

    // ২. CREATE: প্রয়োজনীয় ডিপেন্ডেন্সি ডেটা (Vue এর ড্রপডাউনের জন্য)
    public function create()
{
    // সব এরিয়া এবং টাইপ একসাথে পাঠানো হচ্ছে
    return response()->json([
        'areas' => Area::select('id', 'name')->get(),
        'customer_types' => CustomerType::select('id', 'name')->get(),
        'statuses' => ['active', 'inactive', 'suspended']
    ]);
}

    // ৩. STORE: নতুন কাস্টমার সেভ
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:150',
            'phone' => 'required|string|max:20|unique:customers,phone',
            'email' => 'nullable|email|max:100|unique:customers,email',
            'address' => 'required|string',
            'area_id' => 'required|exists:areas,id',
            'customer_type_id' => 'required|exists:customer_types,id',
            'status' => ['required', Rule::in(['active', 'inactive', 'suspended'])],
        ]);
        
        $customer = Customer::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Customer created successfully.',
            'data' => $customer
        ], 201);
    }

    // ৪. SHOW/EDIT: সিঙ্গেল কাস্টমার ডেটা
    public function show(Customer $customer)
    {
        // রিলেশনসহ ডেটা পাঠানো
        $customer->load(['area', 'customerType']);
        
        return response()->json([
            'success' => true,
            'data' => $customer
        ]);
    }

    // ৫. UPDATE: কাস্টমার আপডেট
    public function update(Request $request, Customer $customer)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:150',
            'phone' => 'required|string|max:20|unique:customers,phone,' . $customer->id,
            'email' => 'nullable|email|max:100|unique:customers,email,' . $customer->id,
            'address' => 'required|string',
            'area_id' => 'required|exists:areas,id',
            'customer_type_id' => 'required|exists:customer_types,id',
            'status' => ['required', Rule::in(['active', 'inactive', 'suspended'])],
        ]);

        $customer->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Customer updated successfully.',
            'data' => $customer
        ]);
    }

    // ৬. DESTROY: কাস্টমার ডিলিট
    public function destroy(Customer $customer)
    {
        $customer->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Customer deleted successfully.'
        ]);
    }
}