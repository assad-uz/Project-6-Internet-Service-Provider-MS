<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Add New Customer</h4>
      </div>
      <div class="card-body">
        
        <div v-if="Object.keys(validationErrors).length" class="alert alert-danger alert-dismissible fade show">
            <ul class="mb-0">
                <template v-for="(errors, field) in validationErrors">
                    <li v-for="(error, index) in errors" :key="field + index">{{ error }}</li>
                </template>
            </ul>
            <button type="button" class="btn-close" @click="validationErrors = {}"></button>
        </div>

        <form @submit.prevent="saveCustomer">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="name" v-model="form.name" required placeholder="Enter full name" />
            </div>

            <div class="col-md-6 mb-3">
              <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="phone" v-model="form.phone" required placeholder="017XXXXXXXX" />
            </div>

            <div class="col-md-6 mb-3">
              <label for="email" class="form-label">Email (Optional)</label>
              <input type="email" class="form-control" id="email" v-model="form.email" placeholder="example@mail.com" />
            </div>

            <div class="col-md-6 mb-3">
              <label for="area_id" class="form-label">Area <span class="text-danger">*</span></label>
              <select class="form-select" id="area_id" v-model="form.area_id" required>
                <option value="" disabled>Select Area</option>
                <option v-for="area in setupData.areas" :key="area.id" :value="area.id">
                  {{ area.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="customer_type_id" class="form-label">Customer Type <span class="text-danger">*</span></label>
              <select class="form-select" id="customer_type_id" v-model="form.customer_type_id" required>
                <option value="" disabled>Select Type</option>
                <option v-for="type in setupData.customer_types" :key="type.id" :value="type.id">
                  {{ type.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
              <select class="form-select" id="status" v-model="form.status" required>
                <option v-for="s in setupData.statuses" :key="s" :value="s">
                  {{ s.charAt(0).toUpperCase() + s.slice(1) }}
                </option>
              </select>
            </div>

            <div class="col-12 mb-3">
              <label for="address" class="form-label">Full Address <span class="text-danger">*</span></label>
              <textarea class="form-control" id="address" v-model="form.address" rows="3" required placeholder="Enter full address"></textarea>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'customers.index' }" class="btn btn-secondary px-4">Back to list</router-link>
            <button type="submit" class="btn btn-primary px-5 shadow-sm" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              Save Customer
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
const submitting = ref(false);
const validationErrors = ref({});

// ড্রপডাউন ডেটা সেট
const setupData = ref({
    areas: [],
    customer_types: [],
    statuses: []
});

// ফর্ম ডাটা অবজেক্ট
const form = ref({
  name: '',
  phone: '',
  email: '',
  area_id: '',
  customer_type_id: '',
  status: 'active',
  address: '',
});

// সার্ভার থেকে ড্রপডাউন ডেটা (Areas, Types, Statuses) লোড করা
const fetchSetupData = async () => {
    try {
        const response = await axios.get('customer-setup-data');
        setupData.value.areas = response.data.areas;
        setupData.value.customer_types = response.data.customer_types;
        setupData.value.statuses = response.data.statuses;
    } catch (error) {
        console.error("Setup data fetch error:", error);
    }
};

// ডাটা সেভ ফাংশন
const saveCustomer = async () => {
    submitting.value = true;
    validationErrors.value = {};

    try {
        const response = await axios.post('customers', form.value);
        if (response.data.success) {
            router.push({ name: 'customers.index' });
        }
    } catch (error) {
        if (error.response && error.response.status === 422) {
            // লারাভেল ভ্যালিডেশন এরর ধরবে (যেমন: ফোন নম্বর অলরেডি এক্সিস্ট করে কি না)
            validationErrors.value = error.response.data.errors;
        } else {
            console.error("Submit error:", error);
            alert("An error occurred. Please try again.");
        }
    } finally {
        submitting.value = false;
    }
};

onMounted(() => {
    fetchSetupData();
});
</script>

<style scoped>
.card { border-radius: 12px; }
.card-header { border-radius: 12px 12px 0 0 !important; }
.form-label { font-weight: 500; }
</style>