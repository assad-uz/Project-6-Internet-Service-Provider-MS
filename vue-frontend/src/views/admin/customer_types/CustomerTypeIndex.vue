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
                <div v-if="loading" class="text-center my-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Fetching Customer Types...</p>
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
                        <tr v-for="(type, index) in customerTypes" :key="type.id">
                            <td class="text-center">{{ index + 1 }}</td>
                            <td>{{ type.name }}</td>
                            <td>{{ formatDate(type.created_at) }}</td>
                            <td class="text-center">
                                <router-link :to="{ name: 'customer_types.edit', params: { id: type.id } }" class="btn btn-warning btn-icon btn-sm">
                                    <i class="bx bx-edit text-white"></i>
                                </router-link>

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
        
        <div class="d-flex justify-content-center mt-3"></div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from '@/axios.js'; // আপনার তৈরি করা Axios instance

// --- স্টেটস ---
const customerTypes = ref([]);
const loading = ref(true);
const successMessage = ref(null);

// --- ফাংশনস ---

// API থেকে ডাটা নিয়ে আসার ফাংশন
const fetchCustomerTypes = async () => {
    loading.value = true;
    try {
        // লারাভেলে paginate(10) ব্যবহার করায় ডাটা response.data.data-তে থাকবে
        const response = await axios.get('customer_types');
        customerTypes.value = response.data.data; 
    } catch (error) {
        console.error("Error fetching customer types:", error);
        alert("Failed to load customer types. Check backend connection.");
    } finally {
        loading.value = false;
    }
};

// তারিখ ফরম্যাট করার ফাংশন
const formatDate = (isoDate) => {
    if (!isoDate) return '';
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
};

// ডিলিট করার ফাংশন
const deleteType = async (typeId) => {
    if (confirm('Are you sure you want to delete this customer type?')) {
        try {
            await axios.delete(`customer_types/${typeId}`);
            
            // রিয়েল-টাইমে লিস্ট থেকে বাদ দেওয়া
            customerTypes.value = customerTypes.value.filter(t => t.id !== typeId);
            
            successMessage.value = 'Customer type deleted successfully!';
            setTimeout(() => { successMessage.value = null; }, 3000);
        } catch (error) {
            console.error("Error deleting customer type:", error);
            alert("Delete failed! This type might be associated with other data.");
        }
    }
};

// পেজ লোড হওয়ার সাথে সাথে API কল হবে
onMounted(() => {
    fetchCustomerTypes();
});
</script>

<style scoped>
.btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.4rem;
}
</style>