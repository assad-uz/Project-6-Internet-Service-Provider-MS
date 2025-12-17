<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Create New Billing Record</h4>
      </div>
      <div class="card-body">
        
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="generateBill">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">Connection (Customer) <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_id" @change="handleConnectionChange" required>
                <option value="" disabled>Select Connection</option>
                <option v-for="conn in connections" :key="conn.id" :value="conn.id">
                  {{ conn.username }} ({{ conn.customer_name }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Billing Month <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.billing_month" required />
              <small class="text-muted">Set to the 1st day of the billing month.</small>
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

          <div class="alert alert-info py-2" v-if="form.amount > 0">
            <strong>Net Payable:</strong> ৳ {{ (form.amount - form.discount).toFixed(2) }}
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'billings.index' }" class="btn btn-secondary">Back to list</router-link>
            <button type="submit" class="btn btn-success">Generate Bill</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const validationErrors = ref([]);

// ডিফল্ট তারিখ ক্যালকুলেশন
const firstDayOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 2).toISOString().split('T')[0];
const tenthDayOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 11).toISOString().split('T')[0];

const form = ref({
  connection_id: '',
  billing_month: firstDayOfMonth,
  amount: 0,
  discount: 0,
  due_date: tenthDayOfMonth,
  status: 'unpaid',
});

// ডামি কানেকশন ডাটা (প্যাকেজ প্রাইস সহ)
const connections = ref([
  { id: 1, username: 'rahim_dhaka', customer_name: 'Rahim Uddin', package_price: 1000 },
  { id: 2, username: 'kashem_ut', customer_name: 'Abul Kashem', package_price: 1500 },
]);

const statuses = ref(['unpaid', 'paid', 'partially_paid', 'cancelled']);

// কানেকশন চেঞ্জ হলে অ্যামাউন্ট সেট করা
const handleConnectionChange = () => {
  const selected = connections.value.find(c => c.id === form.value.connection_id);
  if (selected) {
    form.value.amount = selected.package_price;
  }
};

const formatStatus = (s) => s.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());

const generateBill = () => {
  validationErrors.value = [];
  console.log('Bill Generated:', form.value);
  alert('Billing record created successfully!');
  router.push({ name: 'billings.index' });
};
</script>