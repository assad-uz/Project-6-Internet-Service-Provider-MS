<template>
    <div class="container mt-4">
        
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Area Management</h3>
            
            <router-link :to="{ name: 'areas.create' }" class="btn btn-primary">
                + Create New Area
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <div v-if="loading" class="text-center my-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading areas...</p>
                </div>

                <table v-else class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 65%">Name</th>
                            <th style="width: 15%">Created At</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(area, index) in areas" :key="area.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>{{ area.name }}</td>
                            <td>{{ formatDate(area.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'areas.edit', params: { id: area.id } }" class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

                                <button @click="deleteArea(area.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="areas.length === 0">
                            <td colspan="4" class="text-center text-muted">No areas found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="d-flex justify-content-center mt-3"></div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios';

// --- রিয়েল ডাটা স্টেটস ---
const areas = ref([]);
const loading = ref(true); // ডাটা লোড হওয়ার জন্য লোডিং স্টেট
const successMessage = ref(null);

// --- ফাংশনস ---

// API থেকে সব এরিয়া নিয়ে আসার ফাংশন
const fetchAreas = async () => {
    loading.value = true;
    try {
        const response = await axios.get('areas');
        // যেহেতু লারাভেলে paginate(10) ব্যবহার করেছেন, ডাটা response.data.data-তে থাকে
        areas.value = response.data.data; 
    } catch (error) {
        console.error("Error fetching areas:", error);
        alert("Failed to load areas. Check if Laravel server is running.");
    } finally {
        loading.value = false;
    }
};

// তারিখ ফরম্যাট করার জন্য
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// API ব্যবহার করে ডিলিট করার ফাংশন
const deleteArea = async (id) => {
    if (confirm('Are you sure you want to delete this area?')) {
        try {
            await axios.delete(`areas/${id}`);
            successMessage.value = 'Area deleted successfully!';
            
            // লিস্ট থেকে ডিলিট করা আইটেমটি বাদ দিয়ে আপডেট করা (আবার API কল না করেই)
            areas.value = areas.value.filter(a => a.id !== id);
            
            setTimeout(() => { successMessage.value = null; }, 3000);
        } catch (error) {
            console.error("Error deleting area:", error);
            alert("Could not delete the area. It might be in use.");
        }
    }
};

// পেজ লোড হলে ডাটা ফেচ হবে
onMounted(() => {
    fetchAreas();
});
</script>

<style scoped>
/* আইকন বাটনের জন্য সামান্য স্টাইল */
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
}
</style>