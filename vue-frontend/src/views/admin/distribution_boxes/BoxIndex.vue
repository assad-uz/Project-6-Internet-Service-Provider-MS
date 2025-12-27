<template>
    <div class="container mt-4">
        
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>
        <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Distribution Box Management</h3>
            
            <router-link :to="{ name: 'distribution_boxes.create' }" class="btn btn-primary">
                + Create New Box
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <div v-if="loading" class="text-center my-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Fetching Distribution Boxes...</p>
                </div>

                <table v-else class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 15%">Box Code</th>
                            <th style="width: 25%">Name</th>
                            <th style="width: 20%">Area</th>
                            <th style="width: 15%">Created At</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(box, index) in distributionBoxes" :key="box.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td class="fw-bold">{{ box.box_code }}</td>
                            <td>{{ box.name || 'N/A' }}</td>
                            <td>
                                <span v-if="box.area" class="badge bg-info text-dark">
                                    {{ box.area.name }}
                                </span>
                                <span v-else class="text-danger small italic">No Area Assigned</span>
                            </td>
                            <td>{{ formatDate(box.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'distribution_boxes.edit', params: { id: box.id } }" class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

                                <button @click="deleteBox(box.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="distributionBoxes.length === 0">
                            <td colspan="6" class="text-center text-muted py-4">No distribution boxes found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js'; // Axios instance

// --- স্টেটস ---
const distributionBoxes = ref([]);
const loading = ref(true);
const successMessage = ref(null);
const errorMessage = ref(null);

// --- ডাটা ফেচিং ---
const fetchBoxes = async () => {
    loading.value = true;
    try {
        const response = await axios.get('distribution_boxes');
        // paginate() ব্যবহার করলে ডাটা response.data.data-তে থাকে
        distributionBoxes.value = response.data.data;
    } catch (error) {
        console.error("Error fetching boxes:", error);
        errorMessage.value = "Failed to load distribution boxes.";
    } finally {
        loading.value = false;
    }
};

// তারিখ ফরম্যাট (যেমন: 27 Dec 2025)
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// ডিলিট ফাংশন
const deleteBox = async (id) => {
    if (confirm('Are you sure you want to delete this distribution box?')) {
        try {
            await axios.delete(`distribution_boxes/${id}`);
            // লিস্ট থেকে আইটেমটি ফিল্টার করে সরিয়ে ফেলা
            distributionBoxes.value = distributionBoxes.value.filter(b => b.id !== id);
            successMessage.value = 'Distribution box deleted successfully!';
            setTimeout(() => { successMessage.value = null; }, 3000);
        } catch (error) {
            console.error("Delete error:", error);
            errorMessage.value = "Could not delete the box. It might be linked to customers.";
            setTimeout(() => { errorMessage.value = null; }, 3000);
        }
    }
};

// পেজ লোড হলে ডাটা আনা হবে
onMounted(() => {
    fetchBoxes();
});
</script>

<style scoped>
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
}
.badge {
    font-size: 0.85rem;
}
</style>