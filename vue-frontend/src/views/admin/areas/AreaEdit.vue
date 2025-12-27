<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Area: {{ form.name || 'Loading...' }}</h4>
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
                    <p class="mt-2">Fetching area details...</p>
                </div>

                <form v-else @submit.prevent="updateArea">
                    <div class="mb-3">
                        <label for="name" class="form-label">Area Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" v-model="form.name" required :disabled="saving">
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'areas.index' }" class="btn btn-secondary">Back to list</router-link>
                        
                        <button type="submit" class="btn btn-warning" :disabled="saving">
                            <span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>
                            {{ saving ? 'Updating...' : 'Update Area' }}
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
import axios from '@/axios.js'; // Axios ইনসট্যান্স ইমপোর্ট

const route = useRoute(); // বর্তমান ইউআরএল থেকে আইডি পাওয়ার জন্য
const router = useRouter(); 

const loading = ref(true); // শুরুতে ডাটা নিয়ে আসার জন্য লোডিং
const saving = ref(false); // পরে ডাটা সেভ করার জন্য লোডিং
const areaId = ref(null);
const validationErrors = ref([]);

const form = ref({
    name: '',
});

// ১. API থেকে নির্দিষ্ট এরিয়ার ডাটা নিয়ে আসা (GET Request)
const fetchArea = async (id) => {
    loading.value = true;
    try {
        const response = await axios.get(`areas/${id}`);
        // লারাভেল কন্ট্রোলার থেকে আসা ডাটা ফর্মে বসানো হচ্ছে
        form.value.name = response.data.name; 
    } catch (error) {
        console.error("Error fetching area:", error);
        alert('Area not found or server error!');
        router.push({ name: 'areas.index' });
    } finally {
        loading.value = false;
    }
};

// ২. ডাটা আপডেট করার ফাংশন (PUT Request)
const updateArea = async () => {
    saving.value = true;
    validationErrors.value = []; 

    try {
        // লারাভেলে PUT রিকোয়েস্ট পাঠানো হচ্ছে
        const response = await axios.put(`areas/${areaId.value}`, form.value);
        
        alert(response.data.message || 'Area updated successfully!'); 
        router.push({ name: 'areas.index' });

    } catch (error) {
        // লারাভেল ভ্যালিডেশন এরর (৪২২) হ্যান্ডেল করা
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.errors;
            validationErrors.value = Object.values(errors).flat();
        } else {
            console.error("Update failed:", error);
            alert('Failed to update area. Please try again.');
        }
    } finally {
        saving.value = false;
    }
};

// কম্পোনেন্ট লোড হলে ইউআরএল থেকে আইডি নিয়ে ডাটা আনা শুরু করবে
onMounted(() => {
    areaId.value = route.params.id;
    if (areaId.value) {
        fetchArea(areaId.value);
    }
});
</script>

<style scoped>
.card {
    border-radius: 12px;
}
.card-header {
    border-radius: 12px 12px 0 0 !important;
}
</style>