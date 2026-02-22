<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat round dense icon="arrow_back" @click="goBack" />
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/0.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <q-page class="flex flex-center">
        <div class="q-pa-lg" style="max-width: 500px; width: 100%">
          <q-card>
            <q-card-section class="text-h6 text-center q-pb-none"> Sign In </q-card-section>

            <q-card-section>
              <q-form @submit.prevent="onSubmit" class="q-gutter-md">
                <q-input
                  v-model="form.email"
                  label="Email"
                  type="email"
                  filled
                  outlined
                  rules="[val => val && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val) || 'Valid email required']"
                />

                <q-input
                  v-model="form.password"
                  label="Password"
                  type="password"
                  filled
                  outlined
                  rules="[val => val && val.length >= 6 || 'Password must be at least 6 characters']"
                />

                <q-checkbox v-model="form.rememberMe" label="Remember me" />

                <q-btn
                  unelevated
                  type="submit"
                  color="primary"
                  label="Sign In"
                  size="lg"
                  class="full-width"
                  @click="goToHome"
                />
              </q-form>

              <div class="text-center q-mt-md">
                <span>Don't have an account? </span>
                <q-btn flat color="primary" label="Sign Up" @click="goToSignUp" />
              </div>

              <div class="text-center q-mt-md">
                <q-btn flat color="primary" label="Forgot Password?" />
              </div>
            </q-card-section>
          </q-card>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'

const router = useRouter()
const $q = useQuasar()

const goToSignUp = () => {
  router.push('/signup')
}

const goBack = () => {
  router.push('/signup')
}

const goToHome = () => {
  router.push('/home')
}

const form = ref({
  email: '',
  password: '',
  rememberMe: false,
})

const onSubmit = async () => {
  // Validate form
  if (!form.value.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    $q.notify({
      type: 'negative',
      message: 'Invalid email information',
    })
    return
  }

  if (!form.value.password || form.value.password.length < 6) {
    $q.notify({
      type: 'negative',
      message: 'Invalid password information',
    })
    return
  }

  // Sign in successful - navigate to home
  $q.notify({
    type: 'positive',
    message: 'Sign in successful! Welcome back.',
  })

  // Reset form
  form.value = {
    email: '',
    password: '',
    rememberMe: false,
  }

  // Navigate to home page
  console.log('Sign in successful — navigating to /home')
  await new Promise((r) => setTimeout(r, 250))
  router.push('/home')
}
</script>

<style scoped>
.q-page {
  padding: 0 16px;
}

.q-btn {
  margin: 0 auto !important;
  display: block !important;
  margin-right: 20px !important;
}
</style>
