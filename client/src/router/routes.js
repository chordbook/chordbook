import AuthenticatedView from '@/views/AuthenticatedView.vue'

export default [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/tabs',
    component: () => import('@/views/TabsView.vue'),
    children: [
      {
        path: '',
        redirect: '/home'
      },
      {
        path: '/home',
        name: 'home',
        component: () => import('@/views/HomeView.vue'),
        meta: { selected: 'home' }
      },
      {
        path: '/discover',
        name: 'discover',
        component: () => import('@/views/DiscoverView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/library',
        name: 'library',
        component: AuthenticatedView,
        props: { component: () => import('@/views/LibraryView.vue') },
        meta: { selected: 'library' }
      },
      {
        path: '/songsheets',
        name: 'songsheets',
        component: AuthenticatedView,
        props: { component: () => import('@/views/SongsheetListView.vue') },
        meta: { selected: 'songs' }
      },
      {
        path: '/albums',
        name: 'albums',
        component: AuthenticatedView,
        props: { component: () => import('@/views/AlbumListView.vue') },
        meta: { selected: 'albums' }
      },
      {
        path: '/artists',
        name: 'artists',
        component: AuthenticatedView,
        props: { component: () => import('@/views/ArtistListView.vue') },
        meta: { selected: 'artists' }
      },
      {
        path: '/setlists',
        name: 'setlists',
        component: AuthenticatedView,
        props: { component: () => import('@/views/SetlistListView.vue') },
        meta: { selected: 'setlists' }
      },
      {
        path: '/artists/:id',
        name: 'artist',
        props: true,
        component: () => import('@/views/ArtistView.vue')
      },
      {
        path: '/artists/:id/tracks',
        name: 'artist.tracks',
        props: true,
        component: () => import('@/views/TrackListView.vue')
      },
      {
        path: '/artists/:id/albums',
        name: 'artist.albums',
        component: () => import('@/views/AlbumListView.vue')
      },
      {
        path: '/albums/:id',
        name: 'album',
        props: true,
        component: () => import('@/views/AlbumView.vue')
      },
      {
        path: '/tracks/:id',
        name: 'track',
        props: true,
        component: () => import('@/views/TrackView.vue')
      },
      {
        path: '/genres/:id',
        name: 'genre',
        props: true,
        component: () => import('@/views/GenreView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/genres/:id/tracks',
        name: 'genre.tracks',
        props: true,
        component: () => import('@/views/TrackListView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/genres/:id/albums',
        name: 'genre.albums',
        component: () => import('@/views/AlbumListView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/genres/:id/artists',
        name: 'genre.artists',
        props: true,
        component: () => import('@/views/ArtistListView.vue'),
        meta: { selected: 'discover' }
      },
      {
        path: '/setlists/:id',
        name: 'setlist',
        props: true,
        component: () => import('@/views/SetlistDetailView.vue'),
        meta: { selected: 'setlists' }
      }
    ]
  },
  {
    path: '/songsheets/new',
    name: 'songsheet.new',
    component: AuthenticatedView,
    props: { component: () => import('@/views/SongsheetEditorView.vue') },
    meta: { selected: 'songs' }
  },
  {
    path: '/songsheets/:id/edit',
    name: 'songsheet.edit',
    component: AuthenticatedView,
    props: route => ({
      ...route.params,
      component: () => import('@/views/SongsheetEditorView.vue')
    }),
    meta: { selected: 'songs' }
  },
  {
    path: '/songsheets/:id',
    name: 'songsheet',
    props: true,
    component: () => import('@/views/SongsheetView.vue'),
    meta: { selected: 'songs' }
  },
  {
    path: '/account',
    name: 'account',
    component: AuthenticatedView,
    props: { component: () => import('@/views/AccountView.vue') }
  },
  {
    path: '/tuner',
    name: 'tuner',
    component: () => import('@/views/TunerView.vue')
  },
  {
    path: '/password/forgot',
    name: 'password/forgot',
    component: () => import('@/views/ForgotPasswordView.vue')
  },
  {
    path: '/password/reset',
    name: 'password',
    props: route => route.query,
    component: () => import('@/views/PasswordResetView.vue')
  },
  {
    path: '/:path(.*)*',
    name: '404',
    component: () => import('@/views/NotFound.vue'),
    beforeEnter (to, from, next) {
      if (to.params.path || !to.redirectedFrom) {
        next()
      } else {
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
