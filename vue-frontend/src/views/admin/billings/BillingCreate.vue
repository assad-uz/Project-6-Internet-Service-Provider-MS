<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-success text-white py-3">
        <h4 class="mb-0 fw-bold"><i class="bx bx-plus-circle"></i> Create New Billing Record</h4>
      </div>
      <div class="card-body p-4">

        <div v-if="Object.keys(validationErrors).length" class="alert alert-danger alert-dismissible fade show">
          <ul class="mb-0">
            <template v-for="(errors, field) in validationErrors" :key="field">
              <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
            </template>
          </ul>
          <button type="button" class="btn-close" @click="validationErrors = {}"></button>
        </div>

        <form @submit.prevent="generateBill">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Connection (Customer) <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_id" @change="handleConnectionChange" required
                :disabled="loading">
                <option value="" disabled>Select Connection</option>
                <option v-for="conn in setupData.connections" :key="conn.id" :value="conn.id">
                  {{ conn.username }} ({{ conn.customer?.name || 'N/A' }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Billing Month <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.billing_month" required />
              <small class="text-muted">Set to the 1st day of the billing month.</small>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Total Amount (Before Discount) <span
                  class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text">৳</span>
                <input type="number" step="0.01" class="form-control" v-model="form.amount" required />
              </div>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Discount Amount (BDT)</label>
              <div class="input-group">
                <span class="input-group-text">৳</span>
                <input type="number" step="0.01" class="form-control" v-model="form.discount" />
              </div>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Due Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.due_date" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Status <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.status" required>
                <option v-for="s in setupData.statuses" :key="s" :value="s">
                  {{ formatStatus(s) }}
                </option>
              </select>
            </div>
          </div>

          <div class="alert alert-info border-0 shadow-sm py-3 d-flex justify-content-between align-items-center"
            v-if="form.amount > 0">
            <h5 class="mb-0">Net Payable Amount:</h5>
            <h4 class="mb-0 fw-bold">৳ {{ (form.amount - form.discount).toFixed(2) }}</h4>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'billings.index' }" class="btn btn-outline-secondary px-4">
              <i class="bx bx-arrow-back"></i> Back to list
            </router-link>
            <button type="submit" class="btn btn-success px-5 shadow-sm" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              <i v-else class="bx bx-save"></i> Generate Bill
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from '@/axios.js';

const router = useRouter();
const loading = ref(true);
const submitting = ref(false);
const validationErrors = ref({});

const setupData = ref({
  connections: [],
  statuses: []
});

// ডিফল্ট তারিখ সেট করা (১লা এবং ১০ই তারিখ)
const today = new Date();
const firstDay = new Date(today.getFullYear(), today.getMonth(), 2).toISOString().split('T')[0];
const tenthDay = new Date(today.getFullYear(), today.getMonth(), 11).toISOString().split('T')[0];

const form = ref({
  connection_id: '',
  billing_month: firstDay,
  amount: 0,
  discount: 0,
  due_date: tenthDay,
  status: 'unpaid',
});

// ড্রপডাউন ডাটা লোড করা
const fetchSetupData = async () => {
  try {
    const response = await axios.get('billing-setup');
    setupData.value = response.data;
  } catch (error) {
    console.error("Setup data fetch error:", error);
  } finally {
    loading.value = false;
  }
};

// কানেকশন চেঞ্জ হলে অটোমেটিক প্যাকেজ প্রাইস বসানো
const handleConnectionChange = () => {
  const selected = setupData.value.connections.find(c => c.id === form.value.connection_id);
  if (selected && selected.package) {
    form.value.amount = selected.package.price;
  }
};

const formatStatus = (s) => s.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());

// বিল সেভ করা
const generateBill = async () => {
  submitting.value = true;
  validationErrors.value = {};

  try {
    const response = await axios.post('billings', form.value);
    if (response.data.success) {
      alert(response.data.message);
      router.push({ name: 'billings.index' });
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      validationErrors.value = error.response.data.errors;
    } else {
      alert("Billing generation failed!");
    }
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  fetchSetupData();
});
</script>