import { createWebHistory, createRouter } from 'vue-router'

const routes = [
  {
    path: '/',
    component: () => import('~/views/artists/Index.vue')
  },
  {
    path: '/artists/:id',
    name: 'artist',
    component: () => import('~/views/artists/Show.vue')
  },
  {
    path: '/tuner',
    component: () => import('~/views/Tuner.vue')
  },
  {
    path: '/songs',
    component: () => import('~/views/songs/Index.vue')
  },
  {
    path: '/songs/new',
    component: () => import('~/views/songs/Editor.vue')
  },
  {
    path: '/songs/:id',
    name: 'song',
    component: () => import('~/views/songs/Show.vue')
  },
  {
    path: '/songs/:id/edit',
    name: 'song.edit',
    component: () => import('~/views/songs/Editor.vue'),
    props: true
  },
  {
    path: '/:path(.*)*',
    name: '404',
    component: () => import('~/views/NotFound.vue'),
    beforeEnter (to, from, next) {
      if (to.params.path || !to.redirectedFrom) {
        next()
      } else {
        console.log(to.redirectedFrom)
        // Preserve path of page that redirected here
        next({
          name: '404',
          replace: true,
          // Convert previous path into array
          params: { path: to.redirectedFrom.path.slice(1).split('/') },
          query: to.redirectedFrom.query,
          hash: to.redirectedFrom.hash
        })
      }
    }
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
