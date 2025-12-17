<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-warning text-dark">
        <h4 class="mb-0">Edit Customer: {{ form.name || 'Loading...' }}</h4>
      </div>
      <div class="card-body">
        
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2">Fetching customer details...</p>
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
            <button type="submit" class="btn btn-warning">Update Customer</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();

const loading = ref(true);
const customerId = ref(null);
const validationErrors = ref([]);

const form = ref({
  name: '',
  phone: '',
  email: '',
  area_id: '',
  customer_type_id: '',
  status: '',
  address: '',
});

// ড্রপডাউন ডাটা (সাধারণত এগুলো আলাদা API থেকে আসবে)
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

// ডামি কাস্টমার ডাটা সার্চ ফাংশন
const fetchCustomer = async (id) => {
  loading.value = true;
  
  // ডামি ডাটা সিমুলেশন (বাস্তবে এখানে axios.get হবে)
  setTimeout(() => {
    const dummyData = {
      id: 1,
      name: 'Rahim Uddin',
      phone: '01712345678',
      email: 'rahim@example.com',
      area_id: 1,
      customer_type_id: 1,
      status: 'active',
      address: 'House 12, Road 5, Dhanmondi, Dhaka',
    };

    if (id == dummyData.id) {
      form.value = { ...dummyData };
    } else {
      alert('Customer not found!');
      router.push({ name: 'customers.index' });
    }
    loading.value = false;
  }, 500);
};

const updateCustomer = () => {
  validationErrors.value = [];
  
  // API কল সিমুলেশন
  console.log('Updating customer:', form.value);
  
  alert('Customer updated successfully!');
  router.push({ name: 'customers.index' });
};

onMounted(() => {
  customerId.value = route.params.id;
  if (customerId.value) {
    fetchCustomer(customerId.value);
  }
});
</script>