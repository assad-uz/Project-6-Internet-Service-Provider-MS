<template>
  <div class="container mt-4">
    <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
      {{ successMessage }}
      <button type="button" class="btn-close" @click="successMessage = null"></button>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0">Billing Management</h3>
      <router-link :to="{ name: 'billings.create' }" class="btn btn-primary shadow-sm">
        <i class="bx bx-plus"></i> Create New Bill
      </router-link>
    </div>

    <div class="card p-3 shadow-sm border-0">
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status"></div>
        <p class="mt-2 text-muted">Fetching billing records...</p>
      </div>

      <div v-else class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-dark text-center">
            <tr>
              <th style="width: 5%">#</th>
              <th style="width: 15%">Billing Month</th>
              <th style="width: 20%">Customer (Username)</th>
              <th style="width: 15%">Package</th>
              <th style="width: 10%">Net Amount</th>
              <th style="width: 10%">Due Date</th>
              <th style="width: 10%">Status</th>
              <th style="width: 15%">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(bill, index) in billings" :key="bill.id">
              <td class="text-center">{{ (pagination.current_page - 1) * pagination.per_page + index + 1 }}</td>
              <td class="text-center fw-bold text-primary">{{ formatMonth(bill.billing_month) }}</td>
              <td>
                <strong>{{ bill.customer?.name || 'N/A' }}</strong><br>
                <small class="text-muted"><i class="bx bx-user"></i> {{ bill.connection?.username || 'N/A' }}</small>
              </td>
              <td>
                <div>{{ bill.package?.package_name || 'N/A' }}</div>
                <small v-if="bill.discount > 0" class="text-danger">Discount: ৳ {{ bill.discount }}</small>
              </td>
              <td class="text-end fw-bold text-dark">
                ৳ {{ formatNumber(bill.amount - bill.discount) }}
              </td>
              <td class="text-center">{{ formatDate(bill.due_date) }}</td>
              <td class="text-center">
                <span :class="['badge', getStatusClass(bill.status)]">
                  {{ formatStatus(bill.status) }}
                </span>
              </td>
              <td class="text-center">
                <div class="d-flex justify-content-center gap-1">
                  <router-link :to="{ name: 'billings.invoice', params: { id: bill.id } }" 
                               class="btn btn-info btn-icon btn-sm" title="View Invoice">
                    <i class="bx bx-receipt text-white"></i>
                  </router-link>
                  
                  <router-link :to="{ name: 'billings.edit', params: { id: bill.id } }" 
                               class="btn btn-warning btn-icon btn-sm">
                    <i class="bx bx-edit text-white"></i>
                  </router-link>
                  
                  <button @click="deleteBill(bill.id)" class="btn btn-danger btn-icon btn-sm">
                    <i class="bx bx-trash text-white"></i>
                  </button>
                </div>
              </td>
            </tr>

            <tr v-if="billings.length === 0">
              <td colspan="8" class="text-center py-4 text-muted">No billing records found.</td>
            </tr>
          </tbody>
        </table>
      </div>

      <nav v-if="pagination.last_page > 1" class="mt-3">
        <ul class="pagination pagination-sm justify-content-center mb-0">
          <li class="page-item" :class="{ disabled: !pagination.prev_page_url }">
            <button class="page-link" @click="fetchBillings(pagination.current_page - 1)">Previous</button>
          </li>
          <li class="page-item active"><a class="page-link">{{ pagination.current_page }}</a></li>
          <li class="page-item" :class="{ disabled: !pagination.next_page_url }">
            <button class="page-link" @click="fetchBillings(pagination.current_page + 1)">Next</button>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js';

const billings = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const pagination = ref({});

// এপিআই থেকে ডাটা নিয়ে আসা
const fetchBillings = async (page = 1) => {
  loading.value = true;
  try {
    const response = await axios.get(`billings?page=${page}`);
    if (response.data.success) {
      billings.value = response.data.data.data;
      pagination.value = {
        current_page: response.data.data.current_page,
        last_page: response.data.data.last_page,
        prev_page_url: response.data.data.prev_page_url,
        next_page_url: response.data.data.next_page_url,
        per_page: response.data.data.per_page,
      };
    }
  } catch (error) {
    console.error("Error fetching billings:", error);
  } finally {
    loading.value = false;
  }
};

// বিল ডিলিট করা
const deleteBill = async (id) => {
  if (confirm('Are you sure you want to delete this billing record?')) {
    try {
      const response = await axios.delete(`billings/${id}`);
      if (response.data.success) {
        billings.value = billings.value.filter(b => b.id !== id);
        successMessage.value = 'Billing record deleted successfully!';
        setTimeout(() => successMessage.value = null, 3000);
      }
    } catch (error) {
      console.error("Error deleting connection:", error);
      alert("Could not delete billing record.");
    }
  }
};

// হেল্পার ফাংশনসমূহ
const formatMonth = (dateString) => {
  if (!dateString) return 'N/A';
  const options = { month: 'long', year: 'numeric' };
  return new Date(dateString).toLocaleDateString('en-US', options);
};

const formatDate = (dateString) => {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleDateString('en-GB', {
    day: '2-digit', month: 'short', year: 'numeric'
  });
};

const formatNumber = (num) => {
  return parseFloat(num).toLocaleString(undefined, { minimumFractionDigits: 2 });
};

const formatStatus = (status) => {
  if (!status) return 'N/A';
  return status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
};

const getStatusClass = (status) => {
  const classes = {
    unpaid: 'bg-danger',
    paid: 'bg-success',
    partially_paid: 'bg-warning text-dark',
    cancelled: 'bg-secondary'
  };
  return classes[status] || 'bg-dark';
};

onMounted(() => {
  fetchBillings();
});
</script>

<style scoped>
.btn-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.4rem;
}
</style>