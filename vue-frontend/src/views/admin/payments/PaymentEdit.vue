<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-3">
      <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center py-3">
        <div>
          <h4 class="mb-0 fw-bold"><i class="bx bx-edit"></i> Edit Payment Record</h4>
          <small class="text-dark opacity-75 font-monospace">Transaction Ref: #{{ $route.params.id }}</small>
        </div>
        <span class="badge bg-dark text-white" v-if="currentBillMonth">
          Current Bill: {{ currentBillMonth }}
        </span>
      </div>
      
      <div class="card-body p-4">
        <div v-if="Object.keys(validationErrors).length > 0" class="alert alert-danger shadow-sm">
          <ul class="mb-0">
            <li v-for="(error, field) in validationErrors" :key="field">{{ error[0] }}</li>
          </ul>
        </div>

        <form @submit.prevent="updatePayment">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="billing_id" class="form-label fw-bold">Billing Record <span class="text-danger">*</span></label>
              <select class="form-select shadow-sm" id="billing_id" v-model="form.billing_id" required>
                <option value="" disabled>Select Bill</option>
                <option v-for="bill in billings" :key="bill.id" :value="bill.id">
                  {{ bill.customer?.name }} ({{ formatMonth(bill.billing_month) }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="amount" class="form-label fw-bold">Amount Paid (BDT) <span class="text-danger">*</span></label>
              <div class="input-group shadow-sm">
                <span class="input-group-text bg-light">৳</span>
                <input type="number" step="0.01" class="form-control" id="amount" v-model="form.amount" required>
              </div>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_method" class="form-label fw-bold">Method <span class="text-danger">*</span></label>
              <select class="form-select shadow-sm" id="payment_method" v-model="form.payment_method" required>
                <option v-for="method in paymentMethods" :key="method" :value="method">
                  {{ method.charAt(0).toUpperCase() + method.slice(1) }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="transaction_id" class="form-label fw-bold">Txn ID / Ref</label>
              <input type="text" class="form-control shadow-sm" id="transaction_id" v-model="form.transaction_id">
            </div>

            <div class="col-md-6 mb-3">
              <label for="collected_by" class="form-label fw-bold">Collected By</label>
              <select class="form-select shadow-sm" id="collected_by" v-model="form.collected_by">
                <option value="">N/A</option>
                <option v-for="collector in collectors" :key="collector.id" :value="collector.id">
                  {{ collector.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_date" class="form-label fw-bold">Date</label>
              <input type="date" class="form-control shadow-sm" id="payment_date" v-model="form.payment_date">
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4 border-top pt-3">
            <router-link :to="{ name: 'payments.index' }" class="btn btn-outline-secondary px-4">
              Cancel
            </router-link>
            <button type="submit" class="btn btn-warning px-5 shadow fw-bold" :disabled="isSubmitting">
              <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-1"></span>
              {{ isSubmitting ? 'Updating...' : 'Update Record' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from '@/axios.js';

const route = useRoute();
const router = useRouter();

const form = ref({
  billing_id: '',
  amount: 0,
  payment_method: '',
  transaction_id: '',
  collected_by: '',
  payment_date: '',
});

const currentBillMonth = ref('');
const billings = ref([]);
const paymentMethods = ref(['cash', 'bKash', 'card', 'bank']);
const collectors = ref([]);
const validationErrors = ref({});
const isSubmitting = ref(false);

// সেটআপ ডাটা এবং বর্তমান পেমেন্ট রেকর্ড লোড করা
const loadInitialData = async () => {
  const paymentId = route.params.id;
  try {
    // ১. ড্রপডাউন ডাটা লোড (পেমেন্ট সেটআপ এপিআই থেকে)
    const setupRes = await axios.get('payment-setup');
    billings.value = setupRes.data.billings;
    collectors.value = setupRes.data.collectors;

    // ২. নির্দিষ্ট পেমেন্ট ডাটা লোড
    const response = await axios.get(`payments/${paymentId}`);
    if (response.data.success) {
      const p = response.data.data;
      form.value = {
        billing_id: p.billing_id,
        amount: p.amount,
        payment_method: p.payment_method,
        transaction_id: p.transaction_id,
        collected_by: p.collected_by,
        payment_date: p.payment_date,
      };
      if (p.billing) {
        currentBillMonth.value = new Date(p.billing.billing_month).toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
      }
    }
  } catch (error) {
    console.error("Data loading failed:", error);
    alert("Could not load payment data.");
  }
};

// ডাটা আপডেট করা
const updatePayment = async () => {
  isSubmitting.value = true;
  validationErrors.value = {};
  const paymentId = route.params.id;

  try {
    const response = await axios.put(`payments/${paymentId}`, form.value);
    if (response.data.success) {
      alert("Payment updated and billing status recalculated!");
      router.push({ name: 'payments.index' });
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      validationErrors.value = error.response.data.errors;
    } else {
      alert("Update failed. Check console for details.");
    }
  } finally {
    isSubmitting.value = false;
  }
};

const formatMonth = (date) => new Date(date).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });

onMounted(() => {
  loadInitialData();
});
</script>