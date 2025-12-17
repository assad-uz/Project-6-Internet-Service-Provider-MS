<template>
  <div class="container mt-5">
    <div class="card shadow-lg">
      <div class="card-header bg-success text-white">
        <h4 class="mb-0">Create New Connection</h4>
      </div>
      <div class="card-body">
        
        <div v-if="validationErrors.length" class="alert alert-danger">
          <ul>
            <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="saveConnection">
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
              <label class="form-label">Password <span class="text-danger">*</span></label>
              <input type="text" class="form-control" v-model="form.password" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Connection Type <span class="text-danger">*</span></label>
              <select class="form-select" v-model="form.connection_type" required>
                <option value="" disabled>Select Type</option>
                <option v-for="type in connectionTypes" :key="type" :value="type">{{ type }}</option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">Connection Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" v-model="form.connection_date" required />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">IP Address (Optional)</label>
              <input type="text" class="form-control" v-model="form.ip_address" />
            </div>

            <div class="col-md-6 mb-3">
              <label class="form-label">MAC Address (Optional)</label>
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
            <button type="submit" class="btn btn-success">Save Connection</button>
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
const validationErrors = ref([]);

// আজকের তারিখ ডিফল্ট হিসেবে সেট করা
const today = new Date().toISOString().split('T')[0];

const form = ref({
  customer_id: '',
  package_id: '',
  distribution_box_id: '',
  box_port_number: '',
  username: '',
  password: '',
  connection_type: '',
  connection_date: today,
  ip_address: '',
  mac_address: '',
  status: 'active',
});

// ড্রপডাউনের জন্য ডামি ডাটা
const customers = ref([
  { id: 1, name: 'Rahim Uddin', phone: '01712345678' },
  { id: 2, name: 'Abul Kashem', phone: '01987654321' }
]);

const packages = ref([
  { id: 1, package_name: '10 Mbps Standard' },
  { id: 2, package_name: '20 Mbps Premium' }
]);

const boxes = ref([
  { id: 1, box_code: 'DB-DH-001', area: { name: 'Dhanmondi' } },
  { id: 2, box_code: 'DB-UT-010', area: { name: 'Uttara' } }
]);

const connectionTypes = ref(['PPPoE', 'Static IP', 'Hotspot']);
const statuses = ref(['active', 'suspended', 'terminated']);

const saveConnection = () => {
  validationErrors.value = [];
  
  // কনসোলে ডাটা চেক করা
  console.log('Form Submitted:', form.value);

  alert('Connection created successfully!');
  router.push({ name: 'connections.index' });
};
</script>