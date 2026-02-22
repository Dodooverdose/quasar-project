const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
  },
  {
    path: '/signup',
    component: () => import('layouts/SignUp.vue'),
  },
  {
    path: '/signin',
    component: () => import('layouts/SignIn.vue'),
  },
  {
    path: '/home',
    component: () => import('layouts/HomePage.vue'),
  },
  {
    path: '/profile',
    component: () => import('layouts/UserProfile.vue'),
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
]

export default routes
