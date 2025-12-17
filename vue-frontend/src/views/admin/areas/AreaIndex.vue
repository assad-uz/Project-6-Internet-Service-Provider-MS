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
                <table class="table table-bordered table-striped align-middle">
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
                                <router-link :to="{ name: 'areas.edit', params: { id: area.id } }" class="btn btn-warning btn-sm">Edit</router-link>

                                <button @click="deleteArea(area.id)" class="btn btn-danger btn-sm ms-1">
                                    Delete
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
        
        <div class="d-flex justify-content-center mt-3">
            </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';

// --- ডামি এরিয়া ডেটা ---
const areas = ref([
    { id: 1, name: 'Dhanmondi', created_at: '2025-02-01T10:00:00Z' },
    { id: 2, name: 'Gulshan', created_at: '2025-02-05T11:30:00Z' },
    { id: 3, name: 'Uttara', created_at: '2025-02-10T15:45:00Z' },
]);

const successMessage = ref(null);

// --- ফাংশনস ---

// তারিখ ফরম্যাট করার জন্য
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// ডিলিট করার জন্য
const deleteArea = (id) => {
    if (confirm('Are you sure you want to delete this area?')) {
        // ডামি রিমুভাল লজিক
        areas.value = areas.value.filter(a => a.id !== id);
        successMessage.value = 'Area deleted successfully!';
        setTimeout(() => { successMessage.value = null; }, 3000);
    }
};
</script>

<style scoped>
/* কোনো কাস্টম CSS থাকলে এখানে দিতে পারেন */
</style>