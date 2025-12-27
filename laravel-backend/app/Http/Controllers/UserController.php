<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    // ১. ইউজার লিস্ট (Pagination সহ)
    public function index()
    {
        $users = User::orderBy('id', 'asc')->paginate(10);
        return response()->json([
            'success' => true,
            'data' => $users
        ]);
    }

    // ২. নতুন ইউজার সেভ করা
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:100', 
            'email'    => 'required|email|unique:users,email|max:100', 
            'password' => 'required|string|min:8',
            'phone'    => 'nullable|string|max:20',
            'role'     => 'required|in:admin,manager,technician', 
            'avatar'   => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], 422);
        }

        $userData = [
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
            'phone'    => $request->phone,
            'role'     => $request->role,
        ];
        
        if ($request->hasFile('avatar')) {
            $path = $request->file('avatar')->store('avatars', 'public');
            $userData['avatar'] = $path;
        }
        
        $user = User::create($userData);

        return response()->json([
            'success' => true,
            'message' => 'User created successfully.',
            'user'    => $user
        ], 201);
    }

    // ৩. নির্দিষ্ট ইউজারের ডাটা (Edit করার জন্য)
    public function show($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $user]);
    }

    // ৪. ইউজার আপডেট করা
    public function update(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'name'   => 'required|string|max:100',
            'email'  => 'required|email|max:100|unique:users,email,' . $id,
            'password' => 'nullable|string|min:8',
            'phone'  => 'nullable|string|max:20',
            'role'   => 'required|in:admin,manager,technician',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', 
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }
        
        $userData = [
            'name'  => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'role'  => $request->role,
        ];

        if ($request->filled('password')) {
            $userData['password'] = Hash::make($request->password);
        }

        if ($request->hasFile('avatar')) {
            if ($user->avatar) {
                Storage::disk('public')->delete($user->avatar);
            }
            $path = $request->file('avatar')->store('avatars', 'public');
            $userData['avatar'] = $path;
        }

        $user->update($userData);

        return response()->json([
            'success' => true,
            'message' => 'User updated successfully.',
            'user'    => $user
        ]);
    }

    // ৫. ইউজার ডিলিট করা
    public function destroy($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found'], 404);
        }

        if ($user->avatar) {
            Storage::disk('public')->delete($user->avatar);
        }

        $user->delete();

        return response()->json(['success' => true, 'message' => 'User deleted successfully.']);
    }
}