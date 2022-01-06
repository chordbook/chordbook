import { createWebHistory, createRouter } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'artists',
    component: () => import('~/views/artists/Index.vue')
  },
  {
    path: '/artists/:id',
    name: 'artist',
    component: () => import('~/views/artists/Show.vue')
  },
  {
    path: '/albums/:id',
    name: 'album',
    component: () => import('~/views/albums/Show.vue')
  },
  {
    path: '/tuner',
    component: () => import('~/views/Tuner.vue')
  },
  {
    path: '/songsheets',
    component: () => import('~/views/songsheets/Index.vue')
  },
  {
    path: '/songsheets/new',
    name: 'songsheet.new',
    component: () => import('~/views/songsheets/Editor.vue')
  },
  {
    path: '/songsheets/:id',
    name: 'songsheet',
    component: () => import('~/views/songsheets/Show.vue')
  },
  // {
  //   path: '/tracks/:id/songsheets',
  //   name: 'track.songsheet',
  //   redirect: to => {
  //     api.get('/api/tracks/:id/songsheets')
  //   }
  //   // component: () => import('~/views/songsheets/Show.vue')
  // },
  {
    path: '/songsheets/:id/edit',
    name: 'songsheet.edit',
    component: () => import('~/views/songsheets/Editor.vue'),
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
