<?php

namespace App\Http\Controllers;

use App\Models\Billing;
use App\Models\Connection;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;

class BillingController extends Controller
{
    // 1. INDEX: সমস্ত বিল JSON আকারে পাঠানোর জন্য
    public function index()
    {
        $billings = Billing::with(['customer', 'connection', 'package'])
                            ->orderBy('billing_month', 'desc')
                            ->paginate(10);
                            
        return response()->json([
            'success' => true,
            'data' => $billings
        ]);
    }

    // Vue এর ড্রপডাউনের জন্য প্রয়োজনীয় ডাটা (Setup Data)
    public function setupData()
    {
        $connections = Connection::with('customer')->orderBy('id', 'desc')->get();
        $statuses = ['unpaid', 'paid', 'partially_paid', 'cancelled'];

        return response()->json([
            'connections' => $connections,
            'statuses' => $statuses
        ]);
    }

    // 2. STORE: নতুন বিল সেভ করা
    public function store(Request $request)
    {
        $validated = $request->validate([
            'connection_id' => 'required|exists:connections,id',
            'billing_month' => [
                'required', 
                'date', // Y-m-d format নিশ্চিত করবে
                Rule::unique('billings')->where(function ($query) use ($request) {
                    return $query->where('connection_id', $request->connection_id)
                                 ->where('billing_month', $request->billing_month);
                }),
            ],
            'amount' => 'required|numeric|min:0',
            'due_date' => 'required|date',
            'discount' => 'nullable|numeric|min:0',
            'status' => ['required', Rule::in(['unpaid', 'paid', 'partially_paid', 'cancelled'])],
        ]);
        
        $connection = Connection::findOrFail($validated['connection_id']);
        
        $validated['customer_id'] = $connection->customer_id;
        $validated['package_id'] = $connection->package_id;
        
        $billing = Billing::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Billing record created successfully.',
            'data' => $billing
        ], 201);
    }

    // 3. SHOW/EDIT: একটি নির্দিষ্ট বিলের তথ্য
    public function show($id)
    {
        $billing = Billing::with(['customer', 'connection', 'package'])->findOrFail($id);
        
        return response()->json([
            'success' => true,
            'data' => $billing
        ]);
    }

    // 4. UPDATE: বিল আপডেট করা
    public function update(Request $request, $id)
    {
        $billing = Billing::findOrFail($id);

        $validated = $request->validate([
            'connection_id' => 'required|exists:connections,id',
            'billing_month' => [
                'required', 
                'date',
                Rule::unique('billings')->ignore($billing->id)
                    ->where(function ($query) use ($request) {
                        return $query->where('connection_id', $request->connection_id)
                                     ->where('billing_month', $request->billing_month);
                    }),
            ],
            'amount' => 'required|numeric|min:0',
            'due_date' => 'required|date',
            'discount' => 'nullable|numeric|min:0',
            'status' => ['required', Rule::in(['unpaid', 'paid', 'partially_paid', 'cancelled'])],
        ]);
        
        if ($billing->connection_id != $validated['connection_id']) {
            $connection = Connection::findOrFail($validated['connection_id']);
            $validated['customer_id'] = $connection->customer_id;
            $validated['package_id'] = $connection->package_id;
        }

        $billing->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Billing record updated successfully.',
            'data' => $billing
        ]);
    }

    // 5. DESTROY: বিল ডিলিট করা
    public function destroy($id)
    {
        $billing = Billing::findOrFail($id);
        $billing->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Billing record deleted successfully.'
        ]);
    }
}