<template>
  <div class="invoice-wrapper py-4">
    <div class="no-print text-center mb-4">
      <button @click="printInvoice" class="btn btn-success me-2">
        <i class="bx bx-printer"></i> Print Invoice
      </button>
      <router-link :to="{ name: 'billings.index' }" class="btn btn-secondary">
        Back to List
      </router-link>
    </div>

    <div class="invoice-box shadow-lg" v-if="!loading">
      <div class="invoice-header row align-items-center">
        <div class="col-6">
          <div class="d-flex align-items-center mb-2">
            <img src="/admin-src/assets/img/logo/my_logo.png" alt="SwiftNet Logo" style="width: 50px; height: 50px; margin-right: 10px;">
            <h2 class="mb-0 fw-bold">SwiftNet</h2>
          </div>
          <p class="mb-0">Dhanmondi Road 4</p>
          <p class="mb-0">01717-211311</p>
          <p class="mb-0">support@swiftnet.com</p>
        </div>
        <div class="col-6 text-end">
          <h1 class="text-uppercase text-secondary mb-0">Invoice</h1>
          <p class="mb-0 fw-bold">Invoice #{{ billing.id }}</p>
          <p class="mb-0">Created: {{ formatDate(billing.created_at) }}</p>
          <p class="mb-0 text-danger fw-bold">Due Date: {{ formatDate(billing.due_date) }}</p>
        </div>
      </div>

      <div class="row my-4">
        <div class="col-12 border-bottom mb-2 pb-1">
          <h5 class="fw-bold">Billed To:</h5>
        </div>
        <div class="col-6">
          <p class="mb-1"><strong>Customer:</strong> {{ billing.customer?.name }}</p>
          <p class="mb-1"><strong>Phone:</strong> {{ billing.customer?.phone }}</p>
          <p class="mb-1"><strong>Address:</strong> {{ billing.customer?.address }}</p>
        </div>
        <div class="col-6">
          <p class="mb-1"><strong>Username:</strong> {{ billing.connection?.username }}</p>
          <p class="mb-1"><strong>Package:</strong> {{ billing.package?.name }} ({{ billing.package?.speed }} Mbps)</p>
          <p class="mb-1"><strong>Area:</strong> {{ billing.area }}</p>
        </div>
      </div>

      <table class="table table-sm invoice-table mb-4 border">
        <thead>
          <tr class="table-secondary">
            <th width="50%">Description</th>
            <th class="text-center" width="20%">Billing Month</th>
            <th class="text-end" width="30%">Amount (BDT)</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Monthly Internet Service Fee ({{ billing.package?.name }})</td>
            <td class="text-center">{{ formatMonth(billing.billing_month) }}</td>
            <td class="text-end">{{ formatCurrency(billing.amount) }}</td>
          </tr>
          <tr v-if="billing.discount > 0">
            <td>Discount Applied</td>
            <td></td>
            <td class="text-end text-danger">({{ formatCurrency(billing.discount) }})</td>
          </tr>
          <tr class="table-primary">
            <td colspan="2" class="text-end fw-bold">NET AMOUNT PAYABLE</td>
            <td class="text-end fw-bold">৳ {{ formatCurrency(netAmount) }}</td>
          </tr>
        </tbody>
      </table>

      <div class="row mt-5">
        <div class="col-7">
          <h5 class="border-bottom pb-1 fw-bold">Payment History:</h5>
          <table v-if="billing.payments.length" class="table table-sm table-striped small border">
            <thead>
              <tr>
                <th>Date</th>
                <th>Method</th>
                <th class="text-end">Paid (BDT)</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="payment in billing.payments" :key="payment.id">
                <td>{{ formatDate(payment.payment_date) }}</td>
                <td>{{ payment.payment_method }}</td>
                <td class="text-end">{{ formatCurrency(payment.amount) }}</td>
              </tr>
            </tbody>
          </table>
          <p v-else class="text-muted small">No payments recorded yet.</p>
        </div>
        
        <div class="col-5">
          <div class="total-summary-box p-3 bg-light border rounded position-relative">
            <div class="d-flex justify-content-between mb-1">
              <span>Net Bill:</span>
              <strong>৳ {{ formatCurrency(netAmount) }}</strong>
            </div>
            <div class="d-flex justify-content-between mb-1 text-success">
              <span>Total Paid:</span>
              <strong>৳ {{ formatCurrency(totalPaid) }}</strong>
            </div>
            <div class="d-flex justify-content-between border-top pt-2 h4 mt-2">
              <span>Due:</span>
              <strong :class="dueAmount > 0 ? 'text-danger' : 'text-success'">
                ৳ {{ formatCurrency(dueAmount) }}
              </strong>
            </div>

            <div v-if="dueAmount <= 0" class="paid-stamp">PAID</div>
          </div>
        </div>
      </div>

      <div class="footer text-center mt-5 pt-4 border-top">
        <p class="text-muted small">This is a computer generated invoice. Thank you for being with SwiftNet!</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const loading = ref(true);

// ডামি ডাটা
const billing = ref({
  id: 4521,
  created_at: '2025-10-01',
  due_date: '2025-10-10',
  billing_month: '2025-10-01',
  amount: 1000,
  discount: 50,
  customer: { name: 'Rahim Uddin', phone: '01712-345678', address: 'House 12, Road 4, Dhanmondi' },
  connection: { username: 'rahim_dhaka' },
  package: { name: '10 Mbps Standard', speed: 10 },
  area: 'Dhanmondi',
  payments: [
    { id: 1, payment_date: '2025-10-05', payment_method: 'bKash', amount: 500 },
    { id: 2, payment_date: '2025-10-07', payment_method: 'Cash', amount: 450 }
  ]
});

// ক্যালকুলেশনস
const netAmount = computed(() => billing.value.amount - billing.value.discount);
const totalPaid = computed(() => billing.value.payments.reduce((sum, p) => sum + p.amount, 0));
const dueAmount = computed(() => netAmount.value - totalPaid.value);

// হেল্পার ফাংশনস
const formatCurrency = (val) => parseFloat(val).toLocaleString(undefined, { minimumFractionDigits: 2 });
const formatDate = (date) => new Date(date).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
const formatMonth = (date) => new Date(date).toLocaleDateString('en-GB', { month: 'long', year: 'numeric' });

const printInvoice = () => { window.print(); };

onMounted(() => {
  // বাস্তবে এখানে API কল হবে
  setTimeout(() => { loading.value = false; }, 500);
});
</script>

<style scoped>
.invoice-box {
  max-width: 850px;
  margin: auto;
  padding: 40px;
  background: #fff;
  border: 1px solid #ddd;
  min-height: 1000px;
}

.paid-stamp {
  position: absolute;
  top: 10px;
  right: 10px;
  border: 4px solid #198754;
  color: #198754;
  padding: 5px 15px;
  font-size: 24px;
  font-weight: bold;
  text-transform: uppercase;
  transform: rotate(-20deg);
  opacity: 0.7;
}

@media print {
  .no-print { display: none !important; }
  body { background: none; }
  .invoice-box { box-shadow: none !important; border: none !important; margin: 0; padding: 0; }
  .invoice-wrapper { padding: 0 !important; }
}
</style>