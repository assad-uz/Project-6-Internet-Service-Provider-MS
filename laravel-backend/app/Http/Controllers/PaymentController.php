<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\Billing;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;

class PaymentController extends Controller
{
    // 1. INDEX: সমস্ত পেমেন্ট লিস্ট JSON আকারে
    public function index()
    {
        $payments = Payment::with(['customer', 'billing', 'collector'])
                            ->orderBy('payment_date', 'desc')
                            ->paginate(10); 
                            
        return response()->json([
            'success' => true,
            'data' => $payments
        ]);
    }

    // Vue এর পেমেন্ট ফর্মের জন্য প্রয়োজনীয় ডাটা (Setup Data)
    public function setupData()
    {
        // শুধুমাত্র বকেয়া বিলগুলো (unpaid/partially_paid)
        $billings = Billing::with('customer')
                           ->whereIn('status', ['unpaid', 'partially_paid'])
                           ->orderBy('due_date', 'asc')
                           ->get();

        $collectors = User::select('id', 'name')->orderBy('name')->get(); 
        $paymentMethods = ['cash', 'bKash', 'card', 'bank'];
        
        return response()->json([
            'billings' => $billings,
            'collectors' => $collectors,
            'paymentMethods' => $paymentMethods
        ]);
    }

    // 2. STORE: নতুন পেমেন্ট সেভ এবং বিল স্ট্যাটাস আপডেট
    public function store(Request $request)
    {
        $validated = $request->validate([
            'billing_id' => 'required|exists:billings,id',
            'collected_by' => 'nullable|exists:users,id',
            'payment_method' => ['required', Rule::in(['cash', 'bKash', 'card', 'bank'])],
            'transaction_id' => 'nullable|string|max:100',
            'amount' => 'required|numeric|min:1',
            'payment_date' => 'nullable|date',
        ]);

        $billing = Billing::findOrFail($validated['billing_id']);

        try {
            DB::beginTransaction();

            $validated['customer_id'] = $billing->customer_id;
            if (!isset($validated['payment_date'])) {
                $validated['payment_date'] = now()->toDateString();
            }

            // পেমেন্ট রেকর্ড তৈরি
            $payment = Payment::create($validated);

            // বিলিং স্ট্যাটাস আপডেট
            $this->updateBillingStatus($billing->id);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Payment recorded successfully and billing status updated.',
                'data' => $payment
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Something went wrong: ' . $e->getMessage()
            ], 500);
        }
    }

    // 3. DESTROY: পেমেন্ট ডিলিট এবং স্ট্যাটাস রিক্যালকুলেট
    public function destroy($id)
    {
        $payment = Payment::findOrFail($id);
        $billingId = $payment->billing_id;
        
        try {
            DB::beginTransaction();
            $payment->delete();
            $this->updateBillingStatus($billingId);
            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Payment deleted and billing status updated.'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // ইউটিলিটি মেথড
    protected function updateBillingStatus(int $billingId): void
    {
        $billing = Billing::findOrFail($billingId);
        $totalPaid = $billing->payments()->sum('amount');
        $netAmount = $billing->amount - $billing->discount;
        
        if ($totalPaid >= $netAmount) {
            $billing->status = 'paid';
        } elseif ($totalPaid > 0) {
            $billing->status = 'partially_paid';
        } else {
            $billing->status = 'unpaid';
        }
        $billing->save();
    }
}