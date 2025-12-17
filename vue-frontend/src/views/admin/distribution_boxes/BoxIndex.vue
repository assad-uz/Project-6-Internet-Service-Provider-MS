<template>
    <div class="container mt-4">
        
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Distribution Box Management</h3>
            
            <router-link :to="{ name: 'distribution_boxes.create' }" class="btn btn-primary">
                + Create New Box
            </router-link>
        </div>

        <div class="card p-3 shadow-sm border-0">
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th style="width: 5%">#</th>
                            <th style="width: 15%">Box Code</th>
                            <th style="width: 30%">Name</th>
                            <th style="width: 20%">Area</th>
                            <th style="width: 15%">Created At</th>
                            <th style="width: 15%">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(box, index) in distributionBoxes" :key="box.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>{{ box.box_code }}</td>
                            <td>{{ box.name || 'N/A' }}</td>
                            <td>{{ box.area ? box.area.name : 'Deleted Area' }}</td>
                            <td>{{ formatDate(box.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'distribution_boxes.edit', params: { id: box.id } }" class="btn btn-warning btn-sm">Edit</router-link>

                                <button @click="deleteBox(box.id)" class="btn btn-danger btn-sm ms-1">
                                    Delete
                                </button>
                            </td>
                        </tr>

                        <tr v-if="distributionBoxes.length === 0">
                            <td colspan="6" class="text-center text-muted">No distribution boxes found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="d-flex justify-content-center mt-3">
            </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';

// --- ডামি ডিস্ট্রিবিউশন বক্স ডাটা (Area সহ) ---
const distributionBoxes = ref([
    { 
        id: 1, 
        box_code: 'DB-DH-001', 
        name: 'Splitter Box 01', 
        area: { id: 1, name: 'Dhanmondi' }, 
        created_at: '2025-02-01T10:00:00Z' 
    },
    { 
        id: 2, 
        box_code: 'DB-GL-052', 
        name: 'Main TJ Box', 
        area: { id: 2, name: 'Gulshan' }, 
        created_at: '2025-02-05T11:30:00Z' 
    },
    { 
        id: 3, 
        box_code: 'DB-UT-010', 
        name: 'Building 5 Splitter', 
        area: { id: 3, name: 'Uttara' }, 
        created_at: '2025-02-10T15:45:00Z' 
    },
]);

const successMessage = ref(null);

// তারিখ ফরম্যাট করার ফাংশন
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// ডিলিট করার ফাংশন
const deleteBox = (id) => {
    if (confirm('Are you sure you want to delete this box?')) {
        // ডামি রিমুভাল
        distributionBoxes.value = distributionBoxes.value.filter(b => b.id !== id);
        successMessage.value = 'Distribution box deleted successfully!';
        setTimeout(() => { successMessage.value = null; }, 3000);
    }
};
</script>

<style scoped>
/* প্রয়োজন হলে কাস্টম স্টাইল */
</style>