<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/White.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
        <q-space />
        <q-btn
          flat
          round
          dense
          icon="notifications"
          aria-label="Notifications"
          @click="showNotifications = !showNotifications"
        >
          <q-badge v-if="unreadCount > 0" color="red" floating>{{ unreadCount }}</q-badge>
        </q-btn>
        <q-btn flat round dense icon="account_circle" to="/profile" aria-label="User profile" />
      </q-toolbar>
    </q-header>

    <!-- Notifications Panel -->
    <q-dialog v-model="showNotifications" position="top" seamless>
      <q-card style="width: 380px; max-width: 95vw; margin-top: 60px">
        <q-card-section class="row items-center q-pb-sm">
          <div class="text-h6">Notifications</div>
          <q-space />
          <q-btn flat dense round icon="close" @click="showNotifications = false" />
        </q-card-section>
        <q-separator />
        <q-list v-if="notifications.length > 0" separator>
          <q-item
            v-for="(notif, i) in notifications"
            :key="i"
            :class="{ 'bg-blue-1': !notif.read }"
            clickable
            @click="markAsRead(i)"
          >
            <q-item-section avatar>
              <q-avatar color="primary" text-color="white" icon="person" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ notif.customerName }}</q-item-label>
              <q-item-label caption>{{ notif.message }}</q-item-label>
              <q-item-label caption class="text-grey-6">{{ notif.time }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <div class="row q-gutter-xs">
                <q-btn
                  dense
                  flat
                  round
                  color="positive"
                  icon="check"
                  size="sm"
                  @click.stop="acceptRequest(i)"
                />
                <q-btn
                  dense
                  flat
                  round
                  color="negative"
                  icon="close"
                  size="sm"
                  @click.stop="declineRequest(i)"
                />
              </div>
            </q-item-section>
          </q-item>
        </q-list>
        <q-card-section v-else class="text-center text-grey-5 q-py-lg">
          No Requests Yet
        </q-card-section>
      </q-card>
    </q-dialog>

    <q-page-container>
      <q-page class="page-content">
        <div v-if="loading" class="flex flex-center" style="min-height: 200px">
          <q-spinner-dots size="40px" color="primary" />
        </div>

        <div v-else class="dashboard-card">
          <div class="text-h5 text-center q-mb-sm">Welcome, {{ fullName }}!</div>
          <div class="specialty-row q-mb-lg">
            <q-badge
              :color="specialtyColor"
              class="text-subtitle1"
              style="padding: 8px 20px; font-size: 16px"
            >
              {{ specialtyLabel }}
            </q-badge>
            <img
              v-if="specialtyIcon"
              :src="specialtyIcon"
              :alt="specialtyLabel"
              style="height: 36px; object-fit: contain"
            />
          </div>

          <div class="text-body1 text-grey-7 text-center q-mb-lg">
            You are registered as a <strong>{{ specialtyLabel }}</strong
            >.
            <span v-if="yearsOfExperience !== null">
              You have <strong>{{ yearsOfExperience }}</strong> year{{
                yearsOfExperience === 1 ? '' : 's'
              }}
              of experience.
            </span>
          </div>

          <q-separator class="q-my-md" />

          <div class="text-h6 q-mb-md">Incoming Requests</div>
          <div class="text-body2 text-grey-6 text-center q-pa-lg">
            No requests yet. New job requests will appear here.
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'src/boot/supabase'

const router = useRouter()
const $q = useQuasar()

const loading = ref(true)
const fullName = ref('')
const specialty = ref('')
const yearsOfExperience = ref(null)
const showNotifications = ref(false)
const notifications = ref([])

const unreadCount = computed(() => notifications.value.filter((n) => !n.read).length)

const markAsRead = (index) => {
  notifications.value[index].read = true
}

const acceptRequest = (index) => {
  const notif = notifications.value[index]
  $q.notify({ type: 'positive', message: `Accepted request from ${notif.customerName}` })
  notifications.value.splice(index, 1)
}

const declineRequest = (index) => {
  const notif = notifications.value[index]
  $q.notify({ type: 'warning', message: `Declined request from ${notif.customerName}` })
  notifications.value.splice(index, 1)
}

const specialtyMap = {
  plumber: { label: 'Plumber', icon: '/icons/plumbing.png', color: 'blue' },
  electrician: { label: 'Electrician', icon: '/icons/electrical.png', color: 'amber-8' },
  carpenter: { label: 'Carpenter', icon: '/icons/carpentry.png', color: 'brown' },
  painter: { label: 'Painter', icon: '/icons/painters.png', color: 'purple' },
  kitchen_fitter: { label: 'Kitchen Fitter', icon: '/icons/kitchen.png', color: 'green' },
  drapery_seamstress: { label: 'Drapery Seamstress', icon: '/icons/drapery.png', color: 'pink' },
}

const specialtyLabel = ref('Service Provider')
const specialtyIcon = ref(null)
const specialtyColor = ref('primary')

onMounted(async () => {
  try {
    const {
      data: { user },
    } = await supabase.auth.getUser()

    if (!user) {
      router.push('/signin')
      return
    }

    const meta = user.user_metadata || {}
    fullName.value = meta.full_name || 'Fixer'
    specialty.value = meta.specialty || ''
    yearsOfExperience.value = meta.years_of_experience ?? null

    const info = specialtyMap[specialty.value]
    if (info) {
      specialtyLabel.value = info.label
      specialtyIcon.value = info.icon
      specialtyColor.value = info.color
    }
  } catch (err) {
    console.error('Failed to load user data:', err)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.page-content {
  display: flex;
  justify-content: center;
  padding: 24px 16px;
}

.dashboard-card {
  width: 100%;
  max-width: 600px;
  margin-top: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.specialty-row {
  display: flex;
  align-items: center;
  gap: 10px;
}
</style>
