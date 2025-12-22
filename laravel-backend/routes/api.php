<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AreaController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\BillingController;
use App\Http\Controllers\PackageController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\ConnectionController;
use App\Http\Controllers\CustomerTypeController;
use App\Http\Controllers\DistributionBoxController;

// Vue থেকে ড্যাশবোর্ডের ডাটা পাওয়ার জন্য
Route::get('/dashboard', [DashboardController::class, 'index']);

// API-এর জন্য resource রুট ব্যবহারের নিয়ম কিছুটা আলাদা
// এখানে 'apiResource' ব্যবহার করা হয় কারণ API-তে 'create' এবং 'edit' (HTML Form) লাগে না।

// Users
Route::apiResource('users', UserController::class);

// Customer types
Route::apiResource('customer_types', CustomerTypeController::class);

// Packages
Route::apiResource('packages', PackageController::class);

// Areas
Route::apiResource('areas', AreaController::class);

// Distribution Box
Route::apiResource('distribution_boxes', DistributionBoxController::class);

// Customers
Route::apiResource('customers', CustomerController::class);

// Connections
Route::apiResource('connections', ConnectionController::class);

// Billings
Route::get('billings/{billing}/invoice', [BillingController::class, 'invoice'])->name('billings.invoice');
Route::apiResource('billings', BillingController::class);

// Payments
Route::apiResource('payments', PaymentController::class);

// Reports
Route::get('/reports', [ReportController::class, 'index'])->name('pages.admin.reports.index');