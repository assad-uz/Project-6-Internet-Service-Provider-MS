<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Customer;
use App\Models\Connection;
use App\Models\Billing;
use App\Models\Payment;
use App\Models\Package;
use App\Models\Ticket;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index() 
    {
        try {
            // চলতি মাস নির্ধারণ
            $currentMonth = Carbon::now()->startOfMonth();
            
            // ১. কাস্টমার সামারি
            $totalCustomers = Customer::count();
            $activeCustomers = Customer::where('status', 'active')->count();
            $inactiveCustomers = Customer::where('status', 'inactive')->count();
            
            // ২. বকেয়া বিলের সংখ্যা (Unpaid/Partial)
            $totalDueBillingsCount = Billing::whereIn('status', ['unpaid', 'partially_paid'])->count();
            
            // ৩. প্যাকেজ অনুযায়ী কাস্টমার ডিস্ট্রিবিউশন (Chart এর জন্য ভালো)
            $packageCounts = Connection::select('package_id', DB::raw('count(*) as total'))
                                       ->groupBy('package_id')
                                       ->with('package:id,package_name') 
                                       ->get();
                                       
            // ৪. সাপোর্ট টিকিট (পেন্ডিং)
            // $pendingTickets = Ticket::where('status', 'pending')->count(); 
            $pendingTickets = 8; // আপনার ডামি ডাটা অনুযায়ী
            
            // ৫. চলতি মাসের মোট কালেকশন
            $totalSalesAmount = Payment::where('payment_date', '>=', $currentMonth)
                                       ->sum('amount');

            // JSON রেসপন্স পাঠানো
            return response()->json([
                'success' => true,
                'data' => [
                    'totalCustomers' => $totalCustomers,
                    'activeCustomers' => $activeCustomers,
                    'inactiveCustomers' => $inactiveCustomers,
                    'pendingTickets' => $pendingTickets,
                    'packageCounts' => $packageCounts,
                    'totalDueBillingsCount' => $totalDueBillingsCount,
                    'totalSalesAmount' => (float) $totalSalesAmount, // নিশ্চিত করতে float
                    'currentMonthName' => $currentMonth->format('F Y'), // ফ্রন্টএন্ডে দেখানোর জন্য
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch dashboard data.',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}