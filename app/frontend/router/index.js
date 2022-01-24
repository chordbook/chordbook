import { createRouter, createWebHistory } from '@ionic/vue-router'
import TabsView from '@/views/TabsView.vue'

const routes = [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/tabs',
    component: TabsView,
    children: [
      {
        path: '/home',
        component: () => import('@/views/HomeView.vue')
      },
      {
        path: '/discover',
        name: 'discover',
        component: () => import('@/views/DiscoverView.vue')
      },
      {
        path: '/artists',
        name: 'artists',
        component: () => import('@/views/ArtistListView.vue')
      },
      {
        path: '/artists/:id',
        name: 'artist',
        component: () => import('@/views/ArtistView.vue')
      },
      {
        path: '/albums/:id',
        name: 'album',
        component: () => import('@/views/AlbumView.vue')
      },
      {
        path: '/tracks/:id',
        name: 'track',
        component: () => import('@/views/TrackView.vue')
      },
      {
        path: '/genres/:id',
        name: 'genre',
        component: () => import('@/views/GenreView.vue')
      },
      {
        path: '/songsheets',
        name: 'songsheets',
        component: () => import('@/views/SongsheetListView.vue')
      }
    ]
  },
  {
    path: '/songsheets/:id',
    name: 'songsheet',
    component: () => import('@/views/SongsheetView.vue')
  },
  {
    path: '/tuner',
    name: 'tuner',
    component: () => import('@/views/TunerView.vue')
  },
  {
    path: '/:path(.*)*',
    name: '404',
    component: () => import('@/views/NotFound.vue'),
    beforeEnter (to, from, next) {
      if (to.params.path || !to.redirectedFrom) {
        next()
      } else {
        console.log(to.redirectedFrom)
        // Preserve path of View that redirected here
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

// [
//   {
//     path: '/',
//     redirect: '/discover'
//   },
//   {
//     path: '/discover',
//     component: () => import('@/views/discover/Index.vue'),
//     props: route => route.query,
//     children: [
//       {
//         path: '',
//         name: 'discover',
//         components: {
//           search: () => import('@/views/discover/Search.vue'),
//           browse: () => import('@/views/discover/Browse.vue')
//         }
//       }
//     ]
//   },
//   {
//     path: '/songsheets/new',
//     name: 'songsheet.new',
//     component: () => import('@/views/songsheets/Editor.vue')
//   },
//   {
//     path: '/songsheets/:id/edit',
//     name: 'songsheet.edit',
//     component: () => import('@/views/songsheets/Editor.vue'),
//     props: true
//   },
// ]

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})
