<template>
  <div class="invoice-wrapper py-4">
    <div class="no-print text-center mb-4">
      <button @click="printInvoice" class="btn btn-success me-2 shadow-sm">
        <i class="bx bx-printer"></i> Print Invoice
      </button>
      <router-link :to="{ name: 'billings.index' }" class="btn btn-secondary shadow-sm">
        <i class="bx bx-arrow-back"></i> Back to List
      </router-link>
    </div>

    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <p class="mt-2">Generating Invoice...</p>
    </div>

    <div class="invoice-box shadow-sm" v-else-if="billing">
      <div class="invoice-header row align-items-center">
        <div class="col-6">
          <div class="d-flex align-items-center mb-2">
            <img src="/admin-src/assets/img/logo/my_logo.png" alt="Logo" class="invoice-logo">
            <h2 class="mb-0 fw-bold ms-2 text-primary">SwiftNet</h2>
          </div>
          <p class="mb-0 small">Dhanmondi Road 4, Dhaka</p>
          <p class="mb-0 small">01717-211311</p>
          <p class="mb-0 small text-muted">support@swiftnet.com</p>
        </div>
        <div class="col-6 text-end">
          <h1 class="text-uppercase text-secondary fw-light mb-0">Invoice</h1>
          <p class="mb-0 fw-bold text-dark">#BILL-{{ billing.id }}</p>
          <p class="mb-0 small">Date: {{ formatDate(billing.created_at) }}</p>
          <p class="mb-0 small text-danger fw-bold">Due Date: {{ formatDate(billing.due_date) }}</p>
        </div>
      </div>

      <div class="row my-4 bg-light p-3 rounded">
        <div class="col-6 border-end">
          <h6 class="text-muted text-uppercase small fw-bold">Billed To:</h6>
          <h5 class="fw-bold mb-1">{{ billing.customer?.name }}</h5>
          <p class="mb-0 small"><i class="bx bx-phone"></i> {{ billing.customer?.phone }}</p>
          <p class="mb-0 small"><i class="bx bx-map"></i> {{ billing.customer?.address || 'N/A' }}</p>
        </div>
        <div class="col-6 ps-4">
          <h6 class="text-muted text-uppercase small fw-bold">Service Details:</h6>
          <p class="mb-1 small"><strong>Username:</strong> {{ billing.connection?.username }}</p>
          <p class="mb-1 small"><strong>Package:</strong> {{ billing.package?.package_name }}</p>
          <p class="mb-0 small"><strong>Status:</strong> <span class="badge bg-info text-dark">{{ billing.status }}</span></p>
        </div>
      </div>

      <table class="table invoice-table mb-4">
        <thead class="bg-info  text-white">
          <tr>
            <th class="ps-3">Description</th>
            <th class="text-center">Billing Month</th>
            <th class="text-end pe-3">Amount</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="ps-3">
              <strong>Monthly Internet Service Fee</strong><br>
              <small class="text-muted">Subscription for {{ billing.package?.package_name }}</small>
            </td>
            <td class="text-center">{{ formatMonth(billing.billing_month) }}</td>
            <td class="text-end pe-3">৳ {{ formatCurrency(billing.amount) }}</td>
          </tr>
          <tr v-if="billing.discount > 0">
            <td colspan="2" class="text-end text-muted small">Discount Applied:</td>
            <td class="text-end pe-3 text-danger">- ৳ {{ formatCurrency(billing.discount) }}</td>
          </tr>
          <tr class="table-light border-top border-dark">
            <td colspan="2" class="text-end fw-bold">Net Payable:</td>
            <td class="text-end pe-3 fw-bold">৳ {{ formatCurrency(netAmount) }}</td>
          </tr>
        </tbody>
      </table>

      <div class="row mt-4">
        <div class="col-7">
          <h6 class="fw-bold mb-2 border-bottom pb-1">Payment History:</h6>
          <table v-if="billing.payments && billing.payments.length" class="table table-sm small">
            <thead>
              <tr class="text-muted">
                <th>Date</th>
                <th>Method</th>
                <th class="text-end">Paid</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="payment in billing.payments" :key="payment.id">
                <td>{{ formatDate(payment.payment_date || payment.created_at) }}</td>
                <td>{{ payment.payment_method }}</td>
                <td class="text-end fw-bold text-success">৳ {{ formatCurrency(payment.amount) }}</td>
              </tr>
            </tbody>
          </table>
          <p v-else class="text-muted small italic">No payments recorded for this invoice.</p>
        </div>
        
        <div class="col-5">
          <div class="summary-card p-3 rounded">
            <div class="d-flex justify-content-between mb-1">
              <span>Total Bill:</span>
              <span>৳ {{ formatCurrency(netAmount) }}</span>
            </div>
            <div class="d-flex justify-content-between mb-1 text-success fw-bold">
              <span>Paid Amount:</span>
              <span>৳ {{ formatCurrency(totalPaid) }}</span>
            </div>
            <hr class="my-2">
            <div class="d-flex justify-content-between h5 mb-0">
              <span class="fw-bold">Total Due:</span>
              <span :class="dueAmount > 0 ? 'text-danger fw-bold' : 'text-success fw-bold'">
                ৳ {{ formatCurrency(dueAmount) }}
              </span>
            </div>

            <div v-if="dueAmount <= 0" class="paid-stamp">PAID</div>
          </div>
        </div>
      </div>

      <div class="footer text-center mt-5 pt-4">
        <p class="text-muted small">This is a computer-generated document. No signature required.</p>
        <p class="fw-bold text-primary mb-0">Thank you for being with SwiftNet!</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import axios from '@/axios.js';

const route = useRoute();
const loading = ref(true);
const billing = ref(null);

// ক্যালকুলেশনস (রিয়েল ডাটার উপর ভিত্তি করে)
const netAmount = computed(() => (billing.value?.amount || 0) - (billing.value?.discount || 0));
const totalPaid = computed(() => {
  if (!billing.value?.payments) return 0;
  return billing.value.payments.reduce((sum, p) => sum + parseFloat(p.amount), 0);
});
const dueAmount = computed(() => Math.max(0, netAmount.value - totalPaid.value));

// এপিআই থেকে ইনভয়েস ডাটা আনা
const fetchInvoiceData = async () => {
  loading.value = true;
  try {
    const response = await axios.get(`billings/${route.params.id}`);
    if (response.data.success) {
      billing.value = response.data.data;
    }
  } catch (error) {
    console.error("Invoice error:", error);
    alert("Invoice not found!");
  } finally {
    loading.value = false;
  }
};

const formatCurrency = (val) => parseFloat(val).toFixed(2);
const formatDate = (date) => new Date(date).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
const formatMonth = (date) => new Date(date).toLocaleDateString('en-GB', { month: 'long', year: 'numeric' });

const printInvoice = () => { window.print(); };

onMounted(() => {
  fetchInvoiceData();
});
</script>

<style scoped>
.invoice-box {
  max-width: 800px;
  margin: auto;
  padding: 50px;
  background: #fff;
  border: 1px solid #eee;
  position: relative;
  min-height: 900px;
}

.invoice-logo {
  width: 60px;
  height: 60px;
  object-fit: contain;
}

.summary-card {
  background-color: #f9fafb;
  border: 1px solid #e5e7eb;
}

.paid-stamp {
  position: absolute;
  bottom: 80px;
  right: 50px;
  border: 5px solid #198754;
  color: #198754;
  padding: 10px 30px;
  font-size: 40px;
  font-weight: 900;
  text-transform: uppercase;
  transform: rotate(-15deg);
  opacity: 0.2;
}

.invoice-table th {
  font-size: 0.9rem;
  text-transform: uppercase;
}

@media print {
  .no-print { display: none !important; }
  .invoice-box { 
    border: none !important; 
    box-shadow: none !important;
    padding: 0 !important;
    width: 100% !important;
    max-width: 100% !important;
  }
  body { background-color: #fff !important; }
}
</style>