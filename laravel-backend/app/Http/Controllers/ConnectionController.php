<?php

namespace App\Http\Controllers;

use App\Models\Connection;
use App\Models\Customer;
use App\Models\Package;
use App\Models\DistributionBox;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ConnectionController extends Controller
{
    // 1. INDEX: কানেকশন লিস্ট (JSON)
    public function index()
    {
        $connections = Connection::with(['customer', 'package', 'distributionBox'])
                                 ->orderBy('id', 'desc')
                                 ->paginate(10); 
                                 
        return response()->json([
            'success' => true,
            'data' => $connections
        ]);
    }

    // 2. CREATE: ড্রপডাউনের জন্য প্রয়োজনীয় সব ডেটা একসাথে
    public function create()
    {
        return response()->json([
            'customers' => Customer::select('id', 'name')->orderBy('name')->get(), 
            'packages' => Package::select('id', 'package_name', 'price')->orderBy('package_name')->get(), 
            'boxes' => DistributionBox::select('id', 'box_code')->orderBy('box_code')->get(), 
            'connection_types' => ['Optical Fiber', 'CAT-5', 'UTP'],
            'statuses' => ['active', 'suspended', 'terminated']
        ]);
    }

    // 3. STORE: নতুন কানেকশন সেভ
    public function store(Request $request)
    {
        $validated = $request->validate([
            'customer_id' => 'required|exists:customers,id|unique:connections,customer_id',
            'package_id' => 'required|exists:packages,id',
            'distribution_box_id' => 'required|exists:distribution_boxes,id',
            'username' => 'required|string|max:100|unique:connections,username',
            'password' => 'required|string|min:6|max:255',
            'ip_address' => 'nullable|ipv4',
            'mac_address' => 'nullable|max:20',
            'box_port_number' => 'nullable|integer|min:1|max:65535',
            'connection_type' => ['required', Rule::in(['Optical Fiber', 'CAT-5', 'UTP'])],
            'connection_date' => 'required|date',
            'status' => ['required', Rule::in(['active', 'suspended', 'terminated'])],
        ]);
        
        $connection = Connection::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Connection created successfully.',
            'data' => $connection
        ], 201);
    }

    // 4. SHOW: সিঙ্গেল কানেকশন ডেটা (এডিট করার সময় লাগবে)
    public function show(Connection $connection)
    {
        $connection->load(['customer', 'package', 'distributionBox']);
        return response()->json([
            'success' => true,
            'data' => $connection
        ]);
    }

    // 5. UPDATE: কানেকশন আপডেট
    public function update(Request $request, Connection $connection)
    {
        $validated = $request->validate([
            'customer_id' => 'required|exists:customers,id|unique:connections,customer_id,' . $connection->id, 
            'package_id' => 'required|exists:packages,id',
            'distribution_box_id' => 'required|exists:distribution_boxes,id',
            'username' => 'required|string|max:100|unique:connections,username,' . $connection->id,
            'password' => 'nullable|string|min:6|max:255', 
            'ip_address' => 'nullable|ipv4',
            'mac_address' => 'nullable|max:20',
            'box_port_number' => 'nullable|integer|min:1|max:65535',
            'connection_type' => ['required', Rule::in(['Optical Fiber', 'CAT-5', 'UTP'])],
            'connection_date' => 'required|date',
            'status' => ['required', Rule::in(['active', 'suspended', 'terminated'])],
        ]);
        
        if (empty($validated['password'])) {
            unset($validated['password']);
        }
        
        $connection->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Connection updated successfully.',
            'data' => $connection
        ]);
    }

    // 6. DESTROY: কানেকশন ডিলিট
    public function destroy(Connection $connection)
    {
        $connection->delete();
        return response()->json([
            'success' => true,
            'message' => 'Connection deleted successfully.'
        ]);
    }
}