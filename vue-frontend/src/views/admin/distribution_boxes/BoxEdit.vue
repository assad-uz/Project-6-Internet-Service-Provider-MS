<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Distribution Box: {{ form.box_code || 'Loading...' }}</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>
                
                <div v-if="loading" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Fetching box details and areas...</p>
                </div>

                <form v-else @submit.prevent="updateBox">
                    
                    <div class="mb-3">
                        <label for="box_code" class="form-label">Box Code <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="box_code" v-model="form.box_code" required :disabled="saving">
                    </div>
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Name (Optional)</label>
                        <input type="text" class="form-control" id="name" v-model="form.name" :disabled="saving">
                    </div>

                    <div class="mb-3">
                        <label for="area_id" class="form-label">Area <span class="text-danger">*</span></label>
                        <select class="form-select" id="area_id" v-model="form.area_id" required :disabled="saving">
                            <option value="" disabled>Select an Area</option>
                            <option v-for="area in areas" :key="area.id" :value="area.id">
                                {{ area.name }}
                            </option>
                        </select>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'distribution_boxes.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-warning" :disabled="saving">
                            <span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>
                            {{ saving ? 'Updating...' : 'Update Box' }}
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

const loading = ref(true); // ডেটা ফেচিং স্টেট
const saving = ref(false);  // আপডেট স্টেট
const boxId = ref(null);
const validationErrors = ref([]);
const areas = ref([]); // এপিআই থেকে আসা এরিয়া লিস্ট

const form = ref({
    box_code: '',
    name: '',
    area_id: '',
});

// ১. ড্রপডাউনের জন্য এরিয়া লিস্ট নিয়ে আসা
const fetchAreas = async () => {
    try {
        const response = await axios.get('areas');
        areas.value = response.data.data || response.data;
    } catch (error) {
        console.error("Error fetching areas:", error);
    }
};

// ২. এপিআই থেকে নির্দিষ্ট বক্সের তথ্য লোড করা
const fetchBox = async (id) => {
    try {
        const response = await axios.get(`distribution_boxes/${id}`);
        const data = response.data;
        
        form.value.box_code = data.box_code;
        form.value.name = data.name;
        form.value.area_id = data.area_id;
    } catch (error) {
        console.error("Error fetching box:", error);
        alert('Box not found on server!');
        router.push({ name: 'distribution_boxes.index' });
    }
};

// ৩. তথ্য আপডেট করা
const updateBox = async () => {
    saving.value = true;
    validationErrors.value = [];

    try {
        const response = await axios.put(`distribution_boxes/${boxId.value}`, form.value);
        alert(response.data.message || 'Box updated successfully!');
        router.push({ name: 'distribution_boxes.index' });
    } catch (error) {
        if (error.response && error.response.status === 422) {
            validationErrors.value = Object.values(error.response.data.errors).flat();
        } else {
            console.error("Update error:", error);
            alert('An error occurred during update.');
        }
    } finally {
        saving.value = false;
    }
};

onMounted(async () => {
    boxId.value = route.params.id;
    loading.value = true;
    
    // এরিয়া এবং বক্স ডাটা একসাথে লোড করা
    await Promise.all([fetchAreas(), fetchBox(boxId.value)]);
    
    loading.value = false;
});
</script>

<style scoped>

</style>