import { createRouter, createWebHistory } from '@ionic/vue-router'
import routes from './routes'
import useAuthStore from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from) => {
  const auth = useAuthStore()

  if (to.meta.auth && !auth.isAuthenticated) {
    return { name: 'unauthorized' }
  }
})

export default router
