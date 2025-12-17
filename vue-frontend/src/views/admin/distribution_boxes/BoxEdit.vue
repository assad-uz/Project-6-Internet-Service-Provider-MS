<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-warning text-dark">
                <h4 class="mb-0">Edit Distribution Box: {{ form.box_code || 'Loading...' }}</h4>
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
                    <p class="mt-2">Fetching box details...</p>
                </div>

                <form v-else @submit.prevent="updateBox">
                    
                    <div class="mb-3">
                        <label for="box_code" class="form-label">Box Code <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="box_code" v-model="form.box_code" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Name (Optional)</label>
                        <input type="text" class="form-control" id="name" v-model="form.name">
                    </div>

                    <div class="mb-3">
                        <label for="area_id" class="form-label">Area <span class="text-danger">*</span></label>
                        <select class="form-select" id="area_id" v-model="form.area_id" required>
                            <option value="" disabled>Select an Area</option>
                            <option v-for="area in areas" :key="area.id" :value="area.id">
                                {{ area.name }}
                            </option>
                        </select>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <router-link :to="{ name: 'distribution_boxes.index' }" class="btn btn-secondary">Back to list</router-link>
                        <button type="submit" class="btn btn-warning">Update Box</button>
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
const boxId = ref(null);
const validationErrors = ref([]);

const form = ref({
    box_code: '',
    name: '',
    area_id: '',
});

// ডামি ডাটা (Areas এবং Boxes)
const areas = ref([
    { id: 1, name: 'Dhanmondi' },
    { id: 2, name: 'Gulshan' },
    { id: 3, name: 'Uttara' },
]);

const dummyBoxes = [
    { id: 1, box_code: 'DB-DH-001', name: 'Splitter Box 01', area_id: 1 },
    { id: 2, box_code: 'DB-GL-052', name: 'Main TJ Box', area_id: 2 },
];

// বক্সের তথ্য লোড করার ফাংশন
const fetchBox = async (id) => {
    loading.value = true;
    
    // ডামি সার্চ লজিক
    const boxData = dummyBoxes.find(b => b.id === parseInt(id));
    
    if (boxData) {
        form.value.box_code = boxData.box_code;
        form.value.name = boxData.name;
        form.value.area_id = boxData.area_id;
    } else {
        alert('Box not found!');
        router.push({ name: 'distribution_boxes.index' });
    }
    
    loading.value = false;
};

const updateBox = () => {
    if (!form.value.box_code || !form.value.area_id) {
        validationErrors.value = ['Box Code and Area are required.'];
        return;
    }

    console.log(`Updating Box ID ${boxId.value}:`, form.value);
    alert(`Distribution Box "${form.value.box_code}" updated successfully!`); 
    router.push({ name: 'distribution_boxes.index' });
};

onMounted(() => {
    boxId.value = route.params.id;
    if (boxId.value) {
        fetchBox(boxId.value);
    }
});
</script>