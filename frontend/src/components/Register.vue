<script setup>

import { ref } from 'vue'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth-store'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()
const error = ref(null)
const form = ref({
    name: '',
    username: '',
    password: ''
})

async function register() {
    try {
        const result = await axios.post('http://localhost:3000/register', form.value)
        console.log(result)
        if(result.status == 200) {
            authStore.authUser = result.data.user
            authStore.token = result.data.token
            router.push('/')
        }
        else {
            console.log(result)
            error.value = result.data
        }
    }
    catch(error) {
        console.log(error)
        error.value = error.response.data.message

    }
}

</script>

<template>
    <form @submit.prevent="register">
        <input type="text" placeholder="username" v-model="form.username">
        <input type="text" placeholder="name" v-model="form.name">
        <input type="password" placeholder="password" v-model="form.password">
        {{ error }}
        <button type="submit" @click="register">Register</button>
    </form>
    <router-link to="/login">Login</router-link>
</template>