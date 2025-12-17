<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Area: {{ form.name || 'Loading...' }}</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
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
                        <input type="text" class="form-control" id="name" v-model="form.name" required>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'areas.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-warning">Update Area</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter(); 

const loading = ref(true);
const areaId = ref(null);
const validationErrors = ref([]);

const form = ref({
    name: '',
});

// ডামি ডাটা (লিস্ট পেজের সাথে মিল রেখে)
const dummyAreas = [
    { id: 1, name: 'Dhanmondi' },
    { id: 2, name: 'Gulshan' },
    { id: 3, name: 'Uttara' },
];

// ডাটা ফেচ করার ডামি ফাংশন
const fetchArea = async (id) => {
    loading.value = true;
    
    // ডামি লজিক: আইডি দিয়ে সার্চ করা
    const areaData = dummyAreas.find(a => a.id === parseInt(id));
    
    if (areaData) {
        form.value.name = areaData.name;
    } else {
        alert('Area not found!');
        router.push({ name: 'areas.index' });
    }
    
    loading.value = false;
};

// ডাটা আপডেট করার ফাংশন
const updateArea = () => {
    if (!form.value.name) {
        validationErrors.value = ['Area Name is required.'];
        return;
    }

    // 🎯 এখানে পরবর্তীতে Axios.put কল হবে
    console.log(`Updating Area ID ${areaId.value}:`, form.value);

    alert(`Area "${form.value.name}" updated successfully!`); 
    router.push({ name: 'areas.index' });
};

onMounted(() => {
    areaId.value = route.params.id;
    if (areaId.value) {
        fetchArea(areaId.value);
    }
});
</script>