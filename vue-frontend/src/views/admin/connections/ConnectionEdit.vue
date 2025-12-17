<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-warning text-dark">
        <h4 class="mb-0">Edit Connection: {{ form.username || 'Loading...' }}</h4>
      </div>
      <div class="card-body">
        
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status"></div>
          <p class="mt-2">Fetching connection details...</p>
        </div>

        <form v-else @submit.prevent="updateConnection">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">Customer <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.customer_id" required>
                <option value="" disabled>Select Customer</option>
                <option v-for="c in customers" :key="c.id" :value="c.id">
                  {{ c.name }} ({{ c.phone }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Package <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.package_id" required>
                <option value="" disabled>Select Package</option>
                <option v-for="p in packages" :key="p.id" :value="p.id">
                  {{ p.package_name }}
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Distribution Box <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.distribution_box_id" required>
                <option value="" disabled>Select Box</option>
                <option v-for="b in boxes" :key="b.id" :value="b.id">
                  {{ b.box_code }} ({{ b.area?.name || 'N/A' }})
                </option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Box Port Number</label>
              <input type="number" class="form-control" v-model="form.box_port_number" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Username <span class="text-danger">*</span></label>
              <input type="text" class="form-control" v-model="form.username" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">New Password (Leave blank to keep current)</label>
              <input type="text" class="form-control" v-model="form.password" placeholder="********" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Connection Type <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_type" required>
                <option v-for="type in connectionTypes" :key="type" :value="type">{{ type }}</option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Connection Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.connection_date" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">IP Address</label>
              <input type="text" class="form-control" v-model="form.ip_address" />
            </div>
            <div class="col-md-6 mb-3">
              <label class="form-label">MAC Address</label>
              <input type="text" class="form-control" v-model="form.mac_address" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Status <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.status" required>
                <option v-for="s in statuses" :key="s" :value="s">
                  {{ s.charAt(0).toUpperCase() + s.slice(1) }}
                </option>
              </select>
            </div>
          </div>

          <div class="d-flex justify-content-between mt-4">
            <router-link :to="{ name: 'connections.index' }" class="btn btn-secondary">Back to list</router-link>
            <button type="submit" class="btn btn-warning">Update Connection</button>
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
const validationErrors = ref([]);

const form = ref({
  customer_id: '',
  package_id: '',
  distribution_box_id: '',
  box_port_number: '',
  username: '',
  password: '',
  connection_type: '',
  connection_date: '',
  ip_address: '',
  mac_address: '',
  status: '',
});

// ডামি ডেটা সেট (বাস্তবে API থেকে আসবে)
const customers = ref([{ id: 1, name: 'Rahim Uddin', phone: '01712345678' }]);
const packages = ref([{ id: 1, package_name: '10 Mbps Standard' }]);
const boxes = ref([{ id: 1, box_code: 'DB-DH-001', area: { name: 'Dhanmondi' } }]);
const connectionTypes = ref(['PPPoE', 'Static IP', 'Hotspot']);
const statuses = ref(['active', 'suspended', 'terminated']);

const fetchConnectionDetails = async (id) => {
  loading.value = true;
  // API কল সিমুলেশন
  setTimeout(() => {
    form.value = {
      id: id,
      customer_id: 1,
      package_id: 1,
      distribution_box_id: 1,
      box_port_number: 3,
      username: 'rahim_dhaka',
      password: '', // সিকিউরিটির জন্য ব্ল্যাঙ্ক রাখা হয়
      connection_type: 'PPPoE',
      connection_date: '2025-01-15',
      ip_address: '192.168.10.50',
      mac_address: 'AA:BB:CC:DD:EE:FF',
      status: 'active',
    };
    loading.value = false;
  }, 500);
};

const updateConnection = () => {
  console.log('Updating Data:', form.value);
  alert('Connection updated successfully!');
  router.push({ name: 'connections.index' });
};

onMounted(() => {
  if (route.params.id) {
    fetchConnectionDetails(route.params.id);
  }
});
</script>