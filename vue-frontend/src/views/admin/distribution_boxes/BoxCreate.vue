<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Distribution Box</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul class="mb-0">
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createBox">
                    
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
                        <select class="form-select" id="area_id" v-model="form.area_id" required :disabled="loadingAreas || saving">
                            <option value="" disabled>
                                {{ loadingAreas ? 'Loading areas...' : 'Select an Area' }}
                            </option>
                            <option v-for="area in areas" :key="area.id" :value="area.id">
                                {{ area.name }}
                            </option>
                        </select>
                        <div v-if="!loadingAreas && areas.length === 0" class="text-danger small mt-1">
                            No areas found. Please create an area first.
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'distribution_boxes.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-success" :disabled="saving || loadingAreas">
                            <span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>
                            {{ saving ? 'Saving...' : 'Save Box' }}
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
import axios from '@/axios.js'; // আপনার Axios কনফিগারেশন

const router = useRouter();
const areas = ref([]); // এরিয়া লিস্ট স্টোর করার জন্য
const validationErrors = ref([]);
const loadingAreas = ref(true); // এরিয়া লোডিং স্টেট
const saving = ref(false); // ডাটা সেভিং স্টেট

// ফর্ম ডাটা অবজেক্ট
const form = ref({
    box_code: '',
    name: '',
    area_id: '', 
});

// ১. ডাটাবেস থেকে সব এরিয়া নিয়ে আসার ফাংশন
const fetchAreas = async () => {
    loadingAreas.value = true;
    try {
        const response = await axios.get('areas');
        // যদি এরিয়া লিস্ট প্যাগিনেটেড থাকে তবে response.data.data ব্যবহার করুন
        areas.value = response.data.data || response.data;
    } catch (error) {
        console.error("Error fetching areas:", error);
        validationErrors.value = ["Failed to load areas. Please refresh the page."];
    } finally {
        loadingAreas.value = false;
    }
};

// ২. ডিস্ট্রিবিউশন বক্স সেভ করার ফাংশন
const createBox = async () => {
    saving.value = true;
    validationErrors.value = []; 

    try {
        const response = await axios.post('distribution_boxes', form.value);
        
        alert(response.data.message || 'Box created successfully!'); 
        router.push({ name: 'distribution_boxes.index' }); 

    } catch (error) {
        if (error.response && error.response.status === 422) {
            // লারাভেল ভ্যালিডেশন এররগুলো ধরা
            validationErrors.value = Object.values(error.response.data.errors).flat();
        } else {
            console.error('Submission error:', error);
            alert('Something went wrong. Please try again.');
        }
    } finally {
        saving.value = false;
    }
};

// কম্পোনেন্ট লোড হওয়ার সময় এরিয়া লিস্ট নিয়ে আসা
onMounted(() => {
    fetchAreas();
});
</script>

<style scoped>

</style>