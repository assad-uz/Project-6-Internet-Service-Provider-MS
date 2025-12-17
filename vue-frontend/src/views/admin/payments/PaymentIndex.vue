<template>
  <div class="container mt-4">
    <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
      {{ successMessage }}
      <button type="button" class="btn-close" @click="successMessage = null"></button>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0">Payment Records</h3>
      <router-link :to="{ name: 'payments.create' }" class="btn btn-primary">
        <i class="bx bx-plus"></i> Record New Payment
      </router-link>
    </div>

    <div class="card shadow-sm border-0">
      <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle mb-0">
          <thead class="table-dark">
            <tr class="text-center">
              <th style="width: 5%">#</th>
              <th style="width: 15%">Payment Date</th>
              <th style="width: 20%">Customer (Bill Month)</th>
              <th style="width: 15%">Amount Paid</th>
              <th style="width: 15%">Method / Txn ID</th>
              <th style="width: 15%">Collected By</th>
              <th style="width: 15%">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(payment, index) in payments" :key="payment.id">
              <td class="text-center">{{ index + 1 }}</td>
              <td class="text-center">{{ formatDate(payment.payment_date) }}</td>
              <td>
                <strong>{{ payment.customer?.name || 'N/A' }}</strong><br>
                <small class="text-muted">Bill: {{ formatMonth(payment.billing?.billing_month) }}</small>
              </td>
              <td class="text-end fw-bold">৳ {{ formatNumber(payment.amount) }}</td>
              <td class="text-center">
                <span class="badge bg-info text-dark">{{ payment.payment_method.toUpperCase() }}</span>
                <br>
                <small class="text-muted">{{ payment.transaction_id || 'N/A' }}</small>
              </td>
              <td>
                <i class="bx bx-user-circle"></i> {{ payment.collector?.name || 'N/A' }}
              </td>
              <td class="text-center">
                <router-link :to="{ name: 'payments.edit', params: { id: payment.id } }" 
                             class="btn btn-warning btn-sm me-1">
                  <i class="bx bx-edit"></i> Edit
                </router-link>
                
                <button @click="confirmDelete(payment.id)" class="btn btn-danger btn-sm">
                  <i class="bx bx-trash"></i> Delete
                </button>
              </td>
            </tr>

            <tr v-if="payments.length === 0">
              <td colspan="7" class="text-center text-muted py-4">No payment records found.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const payments = ref([]);
const successMessage = ref(null);

// English: Fetching dummy payment data for initial view
const fetchPayments = () => {
  payments.value = [
    {
      id: 1,
      payment_date: '2025-10-15',
      amount: 1000.00,
      payment_method: 'bKash',
      transaction_id: 'TRX987654321',
      customer: { name: 'Rahim Uddin' },
      billing: { billing_month: '2025-10-01' },
      collector: { name: 'Admin User' }
    },
    {
      id: 2,
      payment_date: '2025-10-16',
      amount: 500.00,
      payment_method: 'cash',
      transaction_id: '',
      customer: { name: 'Abul Kashem' },
      billing: { billing_month: '2025-10-01' },
      collector: { name: 'Staff Member' }
    }
  ];
};

// English: Formatting date to YYYY-MM-DD
const formatDate = (dateString) => {
  if (!dateString) return 'N/A';
  return new Date(dateString).toISOString().split('T')[0];
};

// English: Formatting month to Full Month, Year (e.g., October, 2025)
const formatMonth = (dateString) => {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
};

// English: Formatting currency numbers
const formatNumber = (num) => {
  return parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
};

// English: Handling payment record deletion
const confirmDelete = (id) => {
  if (confirm('WARNING: Are you sure you want to delete this payment? It will recalculate the bill status.')) {
    payments.value = payments.value.filter(p => p.id !== id);
    successMessage.value = "Payment record deleted successfully.";
    // English: Hide message after 3 seconds
    setTimeout(() => successMessage.value = null, 3000);
  }
};

onMounted(() => {
  fetchPayments();
});
</script>

<style scoped>
.table th { font-size: 0.85rem; }
.badge { font-weight: 500; }
</style>