<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-warning text-dark">
        <h4 class="mb-0">Edit Billing Record ({{ formattedMonth }})</h4>
      </div>
      <div class="card-body">
        
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-warning" role="status"></div>
          <p class="mt-2">Loading bill details...</p>
        </div>

        <form v-else @submit.prevent="updateBill">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">Connection (Customer) <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_id" required>
                <option value="" disabled>Select Connection</option>
                <option v-for="conn in connections" :key="conn.id" :value="conn.id">
                  {{ conn.username }} ({{ conn.customer_name }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Billing Month <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.billing_month" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Total Amount (Before Discount) <span class="text-danger">*</span></label>
              <input type="number" step="0.01" class="form-control" v-model="form.amount" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Discount Amount (BDT)</label>
              <input type="number" step="0.01" class="form-control" v-model="form.discount" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Due Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.due_date" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Status <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.status" required>
                <option v-for="s in statuses" :key="s" :value="s">
                  {{ formatStatus(s) }}
                </option>
              </select>
            </div>
          </div>

          <div class="alert alert-warning py-2">
            <strong>Updated Net Payable:</strong> ৳ {{ (form.amount - form.discount).toFixed(2) }}
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'billings.index' }" class="btn btn-secondary">Back to list</router-link>
            <button type="submit" class="btn btn-warning">Update Bill</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const validationErrors = ref([]);

const form = ref({
  connection_id: '',
  billing_month: '',
  amount: 0,
  discount: 0,
  due_date: '',
  status: '',
});

// ডামি ডাটা
const connections = ref([
  { id: 1, username: 'rahim_dhaka', customer_name: 'Rahim Uddin' },
  { id: 2, username: 'kashem_ut', customer_name: 'Abul Kashem' }
]);
const statuses = ref(['unpaid', 'paid', 'partially_paid', 'cancelled']);

// কম্পিউটার প্রোপার্টি: মাসের নাম দেখানোর জন্য (Header)
const formattedMonth = computed(() => {
  if (!form.value.billing_month) return 'Loading...';
  const date = new Date(form.value.billing_month);
  return date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
});

const fetchBillDetails = async (id) => {
  loading.value = true;
  // API Call Simulation
  setTimeout(() => {
    form.value = {
      connection_id: 1,
      billing_month: '2025-10-01',
      amount: 1000,
      discount: 50,
      due_date: '2025-10-10',
      status: 'unpaid',
    };
    loading.value = false;
  }, 500);
};

const formatStatus = (s) => s.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());

const updateBill = () => {
  console.log('Bill Updated:', form.value);
  alert('Billing record updated successfully!');
  router.push({ name: 'billings.index' });
};

onMounted(() => {
  if (route.params.id) {
    fetchBillDetails(route.params.id);
  }
});
</script>