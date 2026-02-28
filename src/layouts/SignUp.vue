<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
      <q-toolbar>
        <q-btn flat round dense icon="arrow_back" @click="goBack" />
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/White.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
      </q-toolbar>
    </q-header>
    <q-page-container style="margin-top: 64px">
      <q-page class="flex flex-center">
        <div class="q-pa-lg" style="max-width: 500px; width: 100%">
          <q-card>
            <q-card-section class="text-h6 text-center q-pb-none"> Create Account </q-card-section>

            <q-card-section>
              <q-form @submit.prevent="onSubmit" class="q-gutter-md">
                <q-input
                  v-model="form.fullName"
                  label="Full Name"
                  type="text"
                  filled
                  outlined
                  rules="[val => val && val.length > 0 || 'Name is required']"
                />

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

                <q-input
                  v-model="form.confirmPassword"
                  label="Confirm Password"
                  type="password"
                  filled
                  outlined
                  rules="[val => val === form.password || 'Passwords must match']"
                />

                <div class="q-mt-md">
                  <div class="text-subtitle2 q-mb-md">Select Role</div>
                  <q-option-group
                    v-model="form.role"
                    :options="[
                      { label: 'Customer', value: 'customer' },
                      { label: 'Fixer', value: 'fixer' },
                    ]"
                    color="primary"
                    inline
                  />
                </div>

                <q-select
                  v-if="form.role === 'fixer'"
                  v-model="form.specialty"
                  label="Select Specialty"
                  filled
                  outlined
                  :options="specialtyOptions"
                  emit-value
                  map-options
                  :rules="[(val) => !!val || 'Please select a specialty']"
                />

                <q-checkbox v-model="form.agreeTerms" label="I agree to the terms and conditions" />

                <q-btn
                  unelevated
                  type="submit"
                  color="primary"
                  label="Sign Up"
                  size="lg"
                  class="full-width"
                  @click="goToHome"
                />
              </q-form>

              <div class="text-center q-mt-md">
                <span>Already have an account? </span>
                <q-btn flat color="primary" label="Sign In" @click="goToSignIn" />
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

const goBack = () => {
  router.push('/')
}

const goToSignIn = () => {
  router.push('/signin')
}

const goToHome = () => {
  router.push('/home')
}

const specialtyOptions = [
  { label: 'Plumber', value: 'plumber' },
  { label: 'Electrician', value: 'electrician' },
  { label: 'Carpenter', value: 'carpenter' },
  { label: 'Painter', value: 'painter' },
  { label: 'Kitchen Fitter', value: 'kitchen_fitter' },
  { label: 'Drapery Seamstress', value: 'drapery_seamstress' },
]

const form = ref({
  fullName: '',
  email: '',
  password: '',
  confirmPassword: '',
  role: '',
  specialty: null,
  agreeTerms: false,
})

const onSubmit = async () => {
  // Validate form
  if (!form.value.fullName || form.value.fullName.length === 0) {
    $q.notify({
      type: 'negative',
      message: 'Full name is required',
    })
    return
  }

  if (!form.value.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    $q.notify({
      type: 'negative',
      message: 'Valid email is required',
    })
    return
  }

  if (!form.value.password || form.value.password.length < 6) {
    $q.notify({
      type: 'negative',
      message: 'Password must be at least 6 characters',
    })
    return
  }

  if (form.value.password !== form.value.confirmPassword) {
    $q.notify({
      type: 'negative',
      message: 'Passwords must match',
    })
    return
  }

  if (!form.value.role) {
    $q.notify({
      type: 'negative',
      message: 'Please select a role',
    })
    return
  }

  if (form.value.role === 'fixer' && !form.value.specialty) {
    $q.notify({
      type: 'negative',
      message: 'Please select a specialty',
    })
    return
  }

  if (!form.value.agreeTerms) {
    $q.notify({
      type: 'negative',
      message: 'You must agree to the terms and conditions',
    })
    return
  }

  // Sign up successful
  $q.notify({
    type: 'positive',
    message: `Welcome ${form.value.fullName}! Account created successfully.`,
  })
  console.log('Sign up successful — navigating to /home')
  await new Promise((r) => setTimeout(r, 250))
  // Navigate to home page
  router.push('/home')
  // Reset form
  form.value = {
    fullName: '',
    email: '',
    password: '',
    confirmPassword: '',
    role: '',
    specialty: null,
    agreeTerms: false,
  }
}
</script>

<style scoped>
.fixed-top {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  right: 0 !important;
  z-index: 1000 !important;
}

:deep(.q-layout) {
  position: static !important;
}

.q-page {
  padding: 0 16px;
}

.q-btn {
  margin: 0 auto !important;
  display: block !important;
  margin-right: 20px !important;
}
</style>
