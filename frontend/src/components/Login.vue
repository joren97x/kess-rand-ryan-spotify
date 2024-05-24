<script setup>

import { ref } from 'vue'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth-store'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()
const error = ref(null)
const form = ref({
    username: '',
    password: ''
})

async function login() {
    try {
        const result = await axios.post("http://localhost:3000/login", form.value)
        console.log(result)
        if(result.status == 200) {
            authStore.authUser = result.data.user
            authStore.token = result.data.token
            router.push('/')
        }
        else {
            error.value = "Invalid credentials"
        }
    }
    catch(err) {
        error.value = "Invalid credentials"
        form.value.password = ''
        console.log(err)
    }
}
</script>

<template>
    <form @submit.prevent="login">
        <input type="text" class="form-control my-2" v-model="form.username" placeholder="username">
        <input type="text" class="form-control" v-model="form.password" placeholder="password">
        {{ error }}
        <button type="submit" class="btn btn-primary mt-2">Login</button>
    </form>
    <router-link to="/register">Register</router-link>
</template>