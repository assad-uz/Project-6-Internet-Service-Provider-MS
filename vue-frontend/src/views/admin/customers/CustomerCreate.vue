<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Add New Customer</h4>
      </div>
      <div class="card-body">
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="saveCustomer">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="name" v-model="form.name" required />
            </div>

            <div class="col-md-6 mb-3">
              <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="phone" v-model="form.phone" required />
            </div>

            <div class="col-md-6 mb-3">
              <label for="email" class="form-label">Email (Optional)</label>
              <input type="email" class="form-control" id="email" v-model="form.email" />
            </div>

            <div class="col-md-6 mb-3">
              <label for="area_id" class="form-label">Area <span class="text-danger">*</span></label>
              <select class="form-select" id="area_id" v-model="form.area_id" required>
                <option value="" disabled>Select Area</option>
                <option v-for="area in areas" :key="area.id" :value="area.id">
                  {{ area.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="customer_type_id" class="form-label">Customer Type <span class="text-danger">*</span></label>
              <select class="form-select" id="customer_type_id" v-model="form.customer_type_id" required>
                <option value="" disabled>Select Type</option>
                <option v-for="type in customerTypes" :key="type.id" :value="type.id">
                  {{ type.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
              <select class="form-select" id="status" v-model="form.status" required>
                <option v-for="s in statuses" :key="s" :value="s">
                  {{ s.charAt(0).toUpperCase() + s.slice(1) }}
                </option>
              </select>
            </div>

            <div class="col-12 mb-3">
              <label for="address" class="form-label">Full Address <span class="text-danger">*</span></label>
              <textarea class="form-control" id="address" v-model="form.address" rows="3" required></textarea>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'customers.index' }" class="btn btn-secondary">Back to list</router-link>
            <button type="submit" class="btn btn-success">Save Customer</button>
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

// ফর্ম ডাটা
const form = ref({
  name: '',
  phone: '',
  email: '',
  area_id: '',
  customer_type_id: '',
  status: 'active',
  address: '',
});

const validationErrors = ref([]);

// ড্রপডাউনের জন্য ডামি ডাটা
const areas = ref([
  { id: 1, name: 'Dhanmondi' },
  { id: 2, name: 'Gulshan' },
  { id: 3, name: 'Uttara' },
]);

const customerTypes = ref([
  { id: 1, name: 'Home User' },
  { id: 2, name: 'Corporate' },
]);

const statuses = ref(['active', 'inactive', 'suspended']);

// সেভ ফাংশন
const saveCustomer = () => {
  validationErrors.value = [];

  // বেসিক ভ্যালিডেশন চেক
  if (!form.value.name || !form.value.phone || !form.value.area_id || !form.value.address) {
    validationErrors.value.push('Please fill in all required fields.');
    return;
  }

  // 🎯 API কলের জন্য জায়গা: axios.post('/api/customers', form.value)
  console.log('Saving customer:', form.value);

  alert('Customer added successfully! (Static Mode)');
  router.push({ name: 'customers.index' });
};
</script>