<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-warning text-dark">
        <h4 class="mb-0">Edit Customer: {{ form.name || 'Loading...' }}</h4>
      </div>
      <div class="card-body">
        
        <div v-if="Object.keys(validationErrors).length" class="alert alert-danger alert-dismissible fade show">
            <ul class="mb-0">
                <template v-for="(errors, field) in validationErrors">
                    <li v-for="(error, index) in errors" :key="field + index">
                        {{ error }}
                    </li>
                </template>
            </ul>
            <button type="button" class="btn-close" @click="validationErrors = {}"></button>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status"></div>
          <p class="mt-2 text-muted">Fetching customer details...</p>
        </div>

        <form v-else @submit.prevent="updateCustomer">
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
              <textarea class="form-control" id="address" v-model="form.address" rows="3" required></textarea>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'customers.index' }" class="btn btn-secondary px-4">Back to list</router-link>
            <button type="submit" class="btn btn-warning px-5 shadow-sm" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              Update Customer
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from '@/axios.js';

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const submitting = ref(false);
const customerId = ref(null);
const validationErrors = ref({});

const setupData = ref({
    areas: [],
    customer_types: [],
    statuses: []
});

const form = ref({
  name: '',
  phone: '',
  email: '',
  area_id: '',
  customer_type_id: '',
  status: '',
  address: '',
});

// CustomerEdit.vue এর fetchData ফাংশনটি রিপ্লেস করুন
const fetchData = async (id) => {
    loading.value = true;
    try {
        const [setupRes, customerRes] = await Promise.all([
            axios.get('customer-setup-data'),
            axios.get(`customers/${id}`)
        ]);

        // ১. ড্রপডাউন ডাটা সেট করা
        setupData.value = setupRes.data;

        // ২. কাস্টমার ডাটা সেট করা (Console Log দিয়ে চেক করুন)
        console.log("Customer Full Response:", customerRes.data);
        
        if (customerRes.data.success) {
            // কন্ট্রোলারের 'data' কি অনুযায়ী অ্যাসাইন করা
            form.value = customerRes.data.data;
        }

    } catch (error) {
        // এই লগটি আপনাকে বলবে আসলে ব্যাকএন্ড থেকে কী এরর আসছে (404 নাকি 500)
        console.error("Fetch Error Response:", error.response);
        
        // সাময়িকভাবে অ্যালার্ট বন্ধ রাখতে পারেন যদি ডিব্যাগ করতে চান
        alert('Fetch Error: ' + (error.response?.statusText || 'Server Error'));
    } finally {
        loading.value = false;
    }
};

// কাস্টমার আপডেট করা
const updateCustomer = async () => {
    submitting.value = true;
    validationErrors.value = {};

    try {
        const response = await axios.put(`customers/${customerId.value}`, form.value);
        if (response.data.success) {
            router.push({ name: 'customers.index' });
        }
    } catch (error) {
        if (error.response && error.response.status === 422) {
            validationErrors.value = error.response.data.errors;
        } else {
            alert("Something went wrong!");
        }
    } finally {
        submitting.value = false;
    }
};

onMounted(() => {
  customerId.value = route.params.id;
  if (customerId.value) {
    fetchData(customerId.value);
  }
});
</script>

<style scoped>
.card { border-radius: 12px; }
.card-header { border-radius: 12px 12px 0 0 !important; }
</style>