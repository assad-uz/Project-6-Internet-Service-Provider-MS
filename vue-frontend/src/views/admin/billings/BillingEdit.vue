<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-warning text-dark py-3">
        <h4 class="mb-0 fw-bold">
          <i class="bx bx-edit"></i> Edit Billing Record ({{ formattedMonth }})
        </h4>
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

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-warning" role="status"></div>
          <p class="mt-2 text-muted">Loading bill details...</p>
        </div>

        <form v-else @submit.prevent="updateBill">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Connection (Customer) <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_id" required>
                <option value="" disabled>Select Connection</option>
                <option v-for="conn in setupData.connections" :key="conn.id" :value="conn.id">
                  {{ conn.username }} ({{ conn.customer?.name || 'N/A' }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Billing Month <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.billing_month" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Total Amount (Before Discount) <span class="text-danger">*</span></label>
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

          <div class="alert alert-warning border-0 shadow-sm py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0 text-dark">Updated Net Payable:</h5>
            <h4 class="mb-0 fw-bold text-dark">৳ {{ (form.amount - form.discount).toFixed(2) }}</h4>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'billings.index' }" class="btn btn-outline-secondary px-4">
              <i class="bx bx-arrow-back"></i> Back to list
            </router-link>
            <button type="submit" class="btn btn-warning px-5 shadow-sm fw-bold" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              <i v-else class="bx bx-save"></i> Update Bill
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from '@/axios.js';

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const submitting = ref(false);
const validationErrors = ref({});

const setupData = ref({
  connections: [],
  statuses: []
});

const form = ref({
  connection_id: '',
  billing_month: '',
  amount: 0,
  discount: 0,
  due_date: '',
  status: '',
});

// মাসের নাম দেখানোর কম্পিউটার প্রোপার্টি
const formattedMonth = computed(() => {
  if (!form.value.billing_month) return '...';
  const date = new Date(form.value.billing_month);
  return date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
});

// ড্রপডাউন ডাটা লোড করা
const fetchSetupData = async () => {
  try {
    const response = await axios.get('billing-setup');
    setupData.value = response.data;
  } catch (error) {
    console.error("Error fetching setup data:", error);
  }
};

// বিলের বিস্তারিত তথ্য লোড করা
const fetchBillDetails = async () => {
  loading.value = true;
  try {
    const response = await axios.get(`billings/${route.params.id}`);
    if (response.data.success) {
      const data = response.data.data;
      form.value = {
        connection_id: data.connection_id,
        billing_month: data.billing_month,
        amount: data.amount,
        discount: data.discount || 0,
        due_date: data.due_date,
        status: data.status,
      };
    }
  } catch (error) {
    console.error("Error fetching bill details:", error);
    alert("Record not found!");
    router.push({ name: 'billings.index' });
  } finally {
    loading.value = false;
  }
};

const formatStatus = (s) => s.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());

// আপডেট কল করা
const updateBill = async () => {
  submitting.value = true;
  validationErrors.value = {};
  try {
    const response = await axios.put(`billings/${route.params.id}`, form.value);
    if (response.data.success) {
      alert(response.data.message);
      router.push({ name: 'billings.index' });
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      validationErrors.value = error.response.data.errors;
    } else {
      alert("Update failed!");
    }
  } finally {
    submitting.value = false;
  }
};

onMounted(async () => {
  await fetchSetupData(); // আগে ড্রপডাউন ডাটা লোড হবে
  if (route.params.id) {
    await fetchBillDetails(); // তারপর বিল ডিটেইলস লোড হবে
  }
});
</script>

<style scoped>
/* টেক্সট ফিল্ড ও আইকন গ্রুপিং */
.input-group-text {
  background-color: #f8f9fa;
  border-right: none;
}
.form-control {
  border-left: none;
}
</style>