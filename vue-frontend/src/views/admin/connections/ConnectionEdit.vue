<template>
  <div class="container mt-5">
    <div class="card shadow-lg border-0">
      <div class="card-header bg-warning text-dark py-3">
        <h4 class="mb-0 fw-bold">
          <i class="bx bx-edit"></i> Edit Connection: {{ form.username || 'Loading...' }}
        </h4>
      </div>
      <div class="card-body p-4">
        
        <div v-if="Object.keys(validationErrors).length" class="alert alert-danger alert-dismissible fade show">
          <ul class="mb-0">
            <template v-for="(errors, field) in validationErrors" :key="field">
              <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
            </template>
          </ul>
          <button type="button" class="btn-close" @click="validationErrors = {}"></button>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-warning" role="status"></div>
          <p class="mt-2 text-muted">Fetching connection details...</p>
        </div>

        <form v-else @submit.prevent="updateConnection">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Customer <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.customer_id" required>
                <option value="" disabled>Select Customer</option>
                <option v-for="c in setupData.customers" :key="c.id" :value="c.id">
                  {{ c.name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Package <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.package_id" required>
                <option value="" disabled>Select Package</option>
                <option v-for="p in setupData.packages" :key="p.id" :value="p.id">
                  {{ p.package_name }} ({{ p.price }} TK)
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Distribution Box <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.distribution_box_id" required>
                <option value="" disabled>Select Box</option>
                <option v-for="b in setupData.boxes" :key="b.id" :value="b.id">
                  {{ b.box_code }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Box Port Number</label>
              <input type="number" class="form-control" v-model="form.box_port_number" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Username <span class="text-danger">*</span></label>
              <input type="text" class="form-control" v-model="form.username" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">New Password (Leave blank to keep current)</label>
              <input type="password" class="form-control" v-model="form.password" placeholder="********" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Connection Type <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_type" required>
                <option v-for="type in setupData.connection_types" :key="type" :value="type">{{ type }}</option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Connection Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.connection_date" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">IP Address</label>
              <input type="text" class="form-control" v-model="form.ip_address" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label fw-bold">Status <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.status" required>
                <option v-for="s in setupData.statuses" :key="s" :value="s">
                  {{ s.charAt(0).toUpperCase() + s.slice(1) }}
                </option>
              </select>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'connections.index' }" class="btn btn-outline-secondary px-4">
              <i class="bx bx-arrow-back"></i> Back to list
            </router-link>
            <button type="submit" class="btn btn-warning px-5 shadow-sm" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              <i v-else class="bx bx-refresh"></i> Update Connection
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
const validationErrors = ref({});
const connectionId = ref(route.params.id);

const setupData = ref({
  customers: [],
  packages: [],
  boxes: [],
  connection_types: [],
  statuses: []
});

const form = ref({
  customer_id: '',
  package_id: '',
  distribution_box_id: '',
  box_port_number: '',
  username: '',
  password: '', // আপডেটের সময় পাসওয়ার্ড অপশনাল
  connection_type: '',
  connection_date: '',
  ip_address: '',
  mac_address: '',
  status: '',
});

// ডাটা লোড করা
const fetchData = async () => {
  loading.value = true;
  try {
    const [setupRes, connectionRes] = await Promise.all([
      axios.get('connection-setup-data'),
      axios.get(`connections/${connectionId.value}`)
    ]);

    setupData.value = setupRes.data;

    if (connectionRes.data.success) {
      const data = connectionRes.data.data;
      // পাসওয়ার্ড বাদে বাকি ডাটা অ্যাসাইন করা
      form.value = { ...data, password: '' };
    }
  } catch (error) {
    console.error("Fetch error:", error);
    alert('Connection details could not be loaded!');
    router.push({ name: 'connections.index' });
  } finally {
    loading.value = false;
  }
};

const updateConnection = async () => {
  submitting.value = true;
  validationErrors.value = {};

  try {
    const response = await axios.put(`connections/${connectionId.value}`, form.value);
    if (response.data.success) {
      alert(response.data.message);
      router.push({ name: 'connections.index' });
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      validationErrors.value = error.response.data.errors;
    } else {
      alert("Update failed!");
    }
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  if (connectionId.value) {
    fetchData();
  }
});
</script>