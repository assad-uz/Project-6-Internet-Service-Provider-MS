<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0"><i class="bx bx-wallet"></i> Record New Payment</h4>
      </div>
      <div class="card-body">
        <div v-if="errors.length > 0" class="alert alert-danger">
          <ul>
            <li v-for="error in errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="savePayment">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="billing_id" class="form-label">Select Bill to Pay <span class="text-danger">*</span></label>
              <select class="form-select" id="billing_id" v-model="form.billing_id" @change="updateDueAmount" required>
                <option value="" disabled>Select an Unpaid/Partially Paid Bill</option>
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
                <option value="" disabled>Select Method</option>
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
              <i class="bx bx-arrow-back"></i> Back to list
            </router-link>
            <button type="submit" class="btn btn-success" :disabled="isSubmitting">
              {{ isSubmitting ? 'Processing...' : 'Record Payment' }}
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

// Form State
const form = ref({
  billing_id: '',
  amount: 0,
  payment_method: '',
  transaction_id: '',
  collected_by: '',
  payment_date: new Date().toISOString().split('T')[0],
});

const errors = ref([]);
const isSubmitting = ref(false);

// Dummy Data (To be replaced by API calls)
const billings = ref([
  { id: 101, customer_name: 'Rahim Uddin', billing_month: '2025-10-01', due_amount: 1000 },
  { id: 102, customer_name: 'Abul Kashem', billing_month: '2025-10-01', due_amount: 1500 },
]);

const paymentMethods = ref(['cash', 'bKash', 'card', 'bank']);

const collectors = ref([
  { id: 1, name: 'Admin User' },
  { id: 2, name: 'Agent Sumon' },
]);

// English: Update amount field automatically when a bill is selected
const updateDueAmount = () => {
  const selectedBill = billings.value.find(b => b.id === form.value.billing_id);
  if (selectedBill) {
    form.value.amount = selectedBill.due_amount;
  }
};

// English: Save payment record logic
const savePayment = async () => {
  isSubmitting.value = true;
  // English: Simulating API submission
  setTimeout(() => {
    console.log('Form Data Submitted:', form.value);
    alert('Payment recorded successfully!');
    isSubmitting.value = false;
    router.push({ name: 'payments.index' });
  }, 1000);
};

// Formatting helpers
const formatMonth = (date) => new Date(date).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
const formatNumber = (num) => parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2 });

onMounted(() => {
  // English: If billId is passed from Billing list, auto-select it
  if (route.params.billId) {
    form.value.billing_id = parseInt(route.params.billId);
    updateDueAmount();
  }
});
</script>

<style scoped>
.card-header { font-weight: bold; }
</style>