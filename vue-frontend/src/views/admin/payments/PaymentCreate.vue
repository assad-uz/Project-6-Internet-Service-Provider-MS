<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-3">
      <div class="card-header bg-success text-white py-3">
        <h4 class="mb-0 fw-bold"><i class="bx bx-wallet"></i> Record New Payment</h4>
      </div>
      <div class="card-body p-4">
        <div v-if="Object.keys(validationErrors).length > 0" class="alert alert-danger shadow-sm">
          <ul class="mb-0">
            <li v-for="(error, field) in validationErrors" :key="field">{{ error[0] }}</li>
          </ul>
        </div>

        <form @submit.prevent="savePayment">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="billing_id" class="form-label fw-bold">Select Bill to Pay <span class="text-danger">*</span></label>
              <select class="form-select shadow-sm" id="billing_id" v-model="form.billing_id" @change="handleBillChange" required>
                <option value="" disabled>Select an Unpaid/Partially Paid Bill</option>
                <option v-for="bill in billings" :key="bill.id" :value="bill.id">
                  {{ bill.customer?.name }} ({{ formatMonth(bill.billing_month) }}) - Due: ৳ {{ calculateDue(bill) }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="amount" class="form-label fw-bold">Payment Amount (BDT) <span class="text-danger">*</span></label>
              <div class="input-group shadow-sm">
                <span class="input-group-text bg-light">৳</span>
                <input type="number" step="0.01" class="form-control" id="amount" v-model="form.amount" placeholder="0.00" required>
              </div>
              <small class="text-muted" v-if="selectedBillDue">Total Due: ৳ {{ selectedBillDue }}</small>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_method" class="form-label fw-bold">Payment Method <span class="text-danger">*</span></label>
              <select class="form-select shadow-sm" id="payment_method" v-model="form.payment_method" required>
                <option value="" disabled>Select Method</option>
                <option v-for="method in paymentMethods" :key="method" :value="method">
                  {{ method.charAt(0).toUpperCase() + method.slice(1) }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="transaction_id" class="form-label fw-bold">Transaction ID / Reference</label>
              <input type="text" class="form-control shadow-sm" id="transaction_id" v-model="form.transaction_id" placeholder="e.g. BKX123456">
            </div>

            <div class="col-md-6 mb-3">
              <label for="collected_by" class="form-label fw-bold">Collected By</label>
              <select class="form-select shadow-sm" id="collected_by" v-model="form.collected_by">
                <option value="">Select Collector (Optional)</option>
                <option v-for="collector in collectors" :key="collector.id" :value="collector.id">
                  {{ collector.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_date" class="form-label fw-bold">Payment Date</label>
              <input type="date" class="form-control shadow-sm" id="payment_date" v-model="form.payment_date">
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4 border-top pt-3">
            <router-link :to="{ name: 'payments.index' }" class="btn btn-outline-secondary px-4">
              <i class="bx bx-arrow-back"></i> Back
            </router-link>
            <button type="submit" class="btn btn-success px-5 shadow" :disabled="isSubmitting">
              <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-1"></span>
              <i v-else class="bx bx-save"></i> {{ isSubmitting ? 'Processing...' : 'Confirm Payment' }}
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

// Form & State
const form = ref({
  billing_id: '',
  amount: '',
  payment_method: 'cash', // Default
  transaction_id: '',
  collected_by: '',
  payment_date: new Date().toISOString().split('T')[0],
});

const billings = ref([]);
const paymentMethods = ref([]);
const collectors = ref([]);
const validationErrors = ref({});
const isSubmitting = ref(false);
const selectedBillDue = ref(0);

// API থেকে সব ডাটা লোড করা
const fetchSetupData = async () => {
  try {
    const response = await axios.get('payment-setup');
    billings.value = response.data.billings;
    paymentMethods.value = response.data.paymentMethods;
    collectors.value = response.data.collectors;

    // যদি ইউআরএল এ billId থাকে (Invoice থেকে আসলে), তবে সেটি সিলেক্ট করা
    if (route.query.billId) {
      form.value.billing_id = parseInt(route.query.billId);
      handleBillChange();
    }
  } catch (error) {
    console.error("Setup data fetch error:", error);
  }
};

// বিল সিলেক্ট করলে বকেয়া টাকা বের করা
const handleBillChange = () => {
  const selectedBill = billings.value.find(b => b.id === form.value.billing_id);
  if (selectedBill) {
    const netAmount = selectedBill.amount - (selectedBill.discount || 0);
    // যদি এপিআই থেকে due_amount না আসে তবে ম্যানুয়ালি ক্যালকুলেট করছি
    selectedBillDue.value = netAmount; 
    form.value.amount = selectedBillDue.value;
  }
};

// পেমেন্ট সেভ করা
const savePayment = async () => {
  isSubmitting.value = true;
  validationErrors.value = {};
  
  try {
    const response = await axios.post('payments', form.value);
    if (response.data.success) {
      alert(response.data.message);
      router.push({ name: 'payments.index' });
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      validationErrors.value = error.response.data.errors;
    } else {
      alert('Something went wrong. Please try again.');
    }
  } finally {
    isSubmitting.value = false;
  }
};

// Helpers
const calculateDue = (bill) => (bill.amount - (bill.discount || 0)).toFixed(2);
const formatMonth = (date) => new Date(date).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });

onMounted(() => {
  fetchSetupData();
});
</script>