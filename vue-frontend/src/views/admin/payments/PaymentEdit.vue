<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
        <div>
          <h4 class="mb-0"><i class="bx bx-edit"></i> Edit Payment Record (ID: {{ $route.params.id }})</h4>
          <small v-if="currentBillMonth" class="text-dark opacity-75">
            Bill Month: {{ currentBillMonth }}
          </small>
        </div>
      </div>
      
      <div class="card-body">
        <div v-if="errors.length > 0" class="alert alert-danger">
          <ul>
            <li v-for="error in errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="updatePayment">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="billing_id" class="form-label">Select Bill to Pay <span class="text-danger">*</span></label>
              <select class="form-select" id="billing_id" v-model="form.billing_id" required>
                <option value="" disabled>Select Bill</option>
                <option v-for="bill in billings" :key="bill.id" :value="bill.id">
                  {{ bill.customer_name }} ({{ formatMonth(bill.billing_month) }}) - Due: ৳ {{ formatNumber(bill.due_amount) }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="amount" class="form-label">Payment Amount (BDT) <span class="text-danger">*</span></label>
              <input type="number" step="0.01" class="form-control" id="amount" v-model="form.amount" required>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_method" class="form-label">Payment Method <span class="text-danger">*</span></label>
              <select class="form-select" id="payment_method" v-model="form.payment_method" required>
                <option v-for="method in paymentMethods" :key="method" :value="method">
                  {{ method.charAt(0).toUpperCase() + method.slice(1) }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="transaction_id" class="form-label">Transaction ID / Reference (Optional)</label>
              <input type="text" class="form-control" id="transaction_id" v-model="form.transaction_id">
            </div>

            <div class="col-md-6 mb-3">
              <label for="collected_by" class="form-label">Collected By (Collector/Agent)</label>
              <select class="form-select" id="collected_by" v-model="form.collected_by">
                <option value="">Self-Collected / Not Applicable</option>
                <option v-for="collector in collectors" :key="collector.id" :value="collector.id">
                  {{ collector.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="payment_date" class="form-label">Payment Date</label>
              <input type="date" class="form-control" id="payment_date" v-model="form.payment_date">
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'payments.index' }" class="btn btn-secondary">
              Back to list
            </router-link>
            <button type="submit" class="btn btn-warning" :disabled="isSubmitting">
              {{ isSubmitting ? 'Updating...' : 'Update Payment' }}
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

const route = useRoute();
const router = useRouter();

// Form Data Structure
const form = ref({
  billing_id: '',
  amount: 0,
  payment_method: '',
  transaction_id: '',
  collected_by: '',
  payment_date: '',
});

const currentBillMonth = ref('');
const errors = ref([]);
const isSubmitting = ref(false);

// Dummy Data for Dropdowns
const billings = ref([
  { id: 101, customer_name: 'Rahim Uddin', billing_month: '2025-10-01', due_amount: 1000 },
  { id: 102, customer_name: 'Abul Kashem', billing_month: '2025-10-01', due_amount: 1500 },
]);
const paymentMethods = ref(['cash', 'bKash', 'card', 'bank']);
const collectors = ref([
  { id: 1, name: 'Admin User' },
  { id: 2, name: 'Agent Sumon' },
]);

// English: Fetch existing payment record data
const loadPaymentData = () => {
  const paymentId = route.params.id;
  // English: Simulated API response with existing data
  const mockData = {
    billing_id: 101,
    amount: 500,
    payment_method: 'bKash',
    transaction_id: 'TRX-EDIT-TEST',
    collected_by: 1,
    payment_date: '2025-10-15',
    bill_month: 'October, 2025'
  };

  form.value = { ...mockData };
  currentBillMonth.value = mockData.bill_month;
};

// English: Update logic (PUT request simulation)
const updatePayment = () => {
  isSubmitting.value = true;
  setTimeout(() => {
    console.log('Updated Payment Data:', form.value);
    alert('Payment record updated successfully!');
    isSubmitting.value = false;
    router.push({ name: 'payments.index' });
  }, 1000);
};

// Helpers
const formatMonth = (date) => new Date(date).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
const formatNumber = (num) => parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2 });

onMounted(() => {
  loadPaymentData();
});
</script>

<style scoped>
.card-header h4 { font-weight: 600; }
</style>