import { createRouter, createWebHistory } from "vue-router"
import { useAuthStore } from "@/stores/auth-store.js"

const router = createRouter({
    history: createWebHistory(null),
    routes: [
        {
            path: '/',
            component: () => import('../components/Homepage.vue'),
            name: 'Test',
        },
        {
            path: '/login',
            component: () => import('../components/Login.vue'),
            name: 'Login',
        },
        {
            path: '/register',
            component: () => import('../components/Register.vue'),
            name: 'Register',
        }
    ]
})

router.beforeEach((to, from, next) => {
    const authStore = useAuthStore()

    if(to.path == '/' && authStore.authUser) {
        next()
    }
    else if(to.path != '/') {
        if(authStore.authUser) {
            next('/')
        }
        else {
            next()
        }
    }
    else {
        next('/login')
    }
})

export default router