import { createRouter, createWebHistory } from '@ionic/vue-router'

const routes = [
  {
    path: '/',
    redirect: '/discover'
  },
  {
    path: '/artists',
    name: 'artists',
    component: () => import('~/views/artists/Index.vue')
  },
  {
    path: '/discover',
    component: () => import('~/views/discover/Index.vue'),
    props: route => route.query,
    children: [
      {
        path: '',
        name: 'discover',
        components: {
          search: () => import('~/views/discover/Search.vue'),
          browse: () => import('~/views/discover/Browse.vue')
        }
      }
    ]
  },
  {
    path: '/genres/:id',
    name: 'genre',
    component: () => import('~/views/discover/Genre.vue')
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
    name: 'tuner',
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
  {
    path: '/tracks/:id',
    name: 'track',
    redirect: to => {
      console.log('Redirecting!', to)
      // api.get('/api/tracks/:id/songsheets')
    }
    // component: () => import('~/views/songsheets/Show.vue')
  },
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
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})
