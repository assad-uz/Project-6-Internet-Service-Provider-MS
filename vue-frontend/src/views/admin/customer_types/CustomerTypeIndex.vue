<template>
    <div class="container mt-4">
        
        <div v-if="successMessage" class="alert alert-success">{{ successMessage }}</div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="mb-0">Customer Types Management</h3>
            
            <router-link :to="{ name: 'customer_types.create' }" class="btn btn-primary">
                + Create New Type
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
                        <tr v-for="(type, index) in customerTypes" :key="type.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>{{ type.name }}</td>
                            <td>{{ formatDate(type.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'customer_types.edit', params: { id: type.id } }" class="btn btn-warning btn-icon btn-sm"><i class="bx bx-edit text-white"></i></router-link>

                                <button @click="deleteType(type.id)" class="btn btn-danger btn-icon btn-sm ms-1">
                                    <i class="bx bx-trash text-white"></i>
                                </button>
                            </td>
                        </tr>

                        <tr v-if="customerTypes.length === 0">
                            <td colspan="4" class="text-center text-muted">No customer types found.</td>
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

// --- ডামি ডেটা ---
const customerTypes = ref([
    { id: 1, name: 'Residential', created_at: '2025-01-15T10:00:00Z' },
    { id: 2, name: 'SME/Office', created_at: '2025-05-20T11:30:00Z' },
    { id: 3, name: 'Corporate', created_at: '2025-10-01T15:45:00Z' },
]);

const successMessage = ref(null);

// --- মেথড এবং লজিক ---

// Date Formatting (d M Y)
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// Delete লজিক (পরে API কল করবে)
const deleteType = (typeId) => {
    if (confirm('Are you sure you want to delete this customer type?')) {
        // 🎯 পরে: এখানে Axios.delete কল করা হবে
        console.log(`Deleting customer type ID: ${typeId}`);
        
        // ডামি রিমুভাল
        customerTypes.value = customerTypes.value.filter(t => t.id !== typeId);
        successMessage.value = 'Customer type deleted successfully!';
        setTimeout(() => { successMessage.value = null; }, 3000);
    }
};
</script>

<style scoped>
/* আপনার স্টাইল যোগ করুন */
</style>