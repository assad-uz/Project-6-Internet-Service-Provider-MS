<template>
  <div class="container mt-4">
    <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>
    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0">Billing Management</h3>
      <router-link :to="{ name: 'billings.create' }" class="btn btn-primary">
        + Create New Bill
      </router-link>
    </div>

    <div class="card p-3 shadow-sm border-0">
      <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle">
          <thead class="table-dark">
            <tr class="text-center">
              <th style="width: 5%">#</th>
              <th style="width: 15%">Billing Month</th>
              <th style="width: 20%">Customer (Username)</th>
              <th style="width: 15%">Package</th>
              <th style="width: 10%">Amount</th>
              <th style="width: 10%">Due Date</th>
              <th style="width: 10%">Status</th>
              <th style="width: 15%">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(bill, index) in billings" :key="bill.id">
              <td class="text-center">{{ index + 1 }}</td>
              <td class="text-center">{{ formatMonth(bill.billing_month) }}</td>
              <td>
                <strong>{{ bill.customer?.name || 'N/A' }}</strong><br>
                <small class="text-muted">({{ bill.connection?.username || 'N/A' }})</small>
              </td>
              <td>{{ bill.package?.package_name || 'N/A' }}</td>
              <td class="text-end">৳ {{ formatNumber(bill.amount - bill.discount) }}</td>
              <td class="text-center">{{ bill.due_date }}</td>
              <td class="text-center">
                <span :class="['badge', getStatusClass(bill.status)]">
                  {{ formatStatus(bill.status) }}
                </span>
              </td>
              <td class="text-center">
                <router-link :to="{ name: 'billings.invoice', params: { id: bill.id } }" 
                             class="btn btn-info btn-sm me-1" title="View Invoice">
                  <i class="bx bx-receipt"></i>
                </router-link>
                
                <router-link :to="{ name: 'billings.edit', params: { id: bill.id } }" 
                             class="btn btn-warning btn-icon btn-sm"><i class="bx bx-edit text-white"></i></router-link>
                
                <button @click="deleteBill(bill.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i></button>
              </td>
            </tr>

            <tr v-if="billings.length === 0">
              <td colspan="8" class="text-center text-muted">No billing records found.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const successMessage = ref(null);
const errorMessage = ref(null);

// ডামি বিলিং ডাটা
const billings = ref([
  {
    id: 101,
    billing_month: '2025-10-01',
    amount: 1000,
    discount: 50,
    due_date: '2025-10-10',
    status: 'paid',
    customer: { name: 'Rahim Uddin' },
    connection: { username: 'rahim_dhaka' },
    package: { package_name: '10 Mbps Standard' }
  },
  {
    id: 102,
    billing_month: '2025-10-01',
    amount: 1500,
    discount: 0,
    due_date: '2025-10-10',
    status: 'unpaid',
    customer: { name: 'Abul Kashem' },
    connection: { username: 'kashem_ut' },
    package: { package_name: '20 Mbps Premium' }
  }
]);

// হেল্পার ফাংশনসমূহ
const formatMonth = (dateString) => {
  const options = { month: 'long', year: 'numeric' };
  return new Date(dateString).toLocaleDateString('en-US', options);
};

const formatNumber = (num) => {
  return parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2 });
};

const formatStatus = (status) => {
  return status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
};

const getStatusClass = (status) => {
  const classes = {
    unpaid: 'bg-danger',
    paid: 'bg-success',
    partially_paid: 'bg-warning',
    cancelled: 'bg-secondary'
  };
  return classes[status] || 'bg-dark';
};

const deleteBill = (id) => {
  if (confirm('Are you sure you want to delete this bill?')) {
    billings.value = billings.value.filter(b => b.id !== id);
    successMessage.value = 'Billing record deleted successfully!';
    setTimeout(() => successMessage.value = null, 3000);
  }
};
</script>