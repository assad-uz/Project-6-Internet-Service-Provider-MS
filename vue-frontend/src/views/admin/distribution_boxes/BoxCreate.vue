<template>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">Create New Distribution Box</h4>
            </div>
            <div class="card-body">

                <div v-if="validationErrors.length" class="alert alert-danger">
                    <ul>
                        <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
                    </ul>
                </div>

                <form @submit.prevent="createBox">
                    
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
                        <button type="submit" class="btn btn-success">Save Box</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'; 

const router = useRouter();

// ফর্ম ডাটা অবজেক্ট
const form = ref({
    box_code: '',
    name: '',
    area_id: '', // সিলেক্ট করা এরিয়ার আইডি এখানে থাকবে
});

// ডামি এরিয়া ডাটা (যা ড্রপডাউনে দেখাবে)
const areas = ref([
    { id: 1, name: 'Dhanmondi' },
    { id: 2, name: 'Gulshan' },
    { id: 3, name: 'Uttara' },
]);

const validationErrors = ref([]);

const createBox = () => {
    // বেসিক ভ্যালিডেশন
    if (!form.value.box_code || !form.value.area_id) {
        validationErrors.value = ['Box Code and Area are required.'];
        return;
    }
    
    validationErrors.value = []; 
    
    // 🎯 পরবর্তীতে এখানে API কল হবে
    console.log('New Box Data:', form.value);

    alert('Distribution Box created successfully! (Static Mode)'); 
    router.push({ name: 'distribution_boxes.index' }); 
};

// আপনি চাইলে এখানে onMounted এ API থেকে Area লিস্ট লোড করার লজিক লিখে রাখতে পারেন
onMounted(() => {
    // fetchAreas();
});
</script>