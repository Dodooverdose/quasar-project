<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
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
              <q-avatar color="primary" text-color="white" icon="build" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ notif.fixerName }}</q-item-label>
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
                  @click.stop="acceptOffer(i)"
                />
                <q-btn
                  dense
                  flat
                  round
                  color="negative"
                  icon="close"
                  size="sm"
                  @click.stop="declineOffer(i)"
                />
              </div>
            </q-item-section>
          </q-item>
        </q-list>
        <q-card-section v-else class="text-center text-grey-5 q-py-lg">
          No Offers Yet
        </q-card-section>
      </q-card>
    </q-dialog>
    <q-page-container>
      <q-page class="flex flex-center">
        <div class="home-grid q-pa-md">
          <div
            v-for="(item, idx) in items"
            :key="idx"
            class="grid-item"
            @click="goToPage(item.route)"
          >
            <div class="icon-box">
              <img :src="item.icon" alt="icon" />
            </div>
            <div class="label">{{ item.label }}</div>
          </div>
        </div>
        <div class="footer-area">
          <div class="icon-buttons">
            <a href="#" target="_blank">
              <img src="/icons/facebook.png" alt="Facebook" class="social-img" />
            </a>
            <a href="#" target="_blank">
              <img src="/icons/x.png" alt="X" class="social-img" />
            </a>
            <a href="#" target="_blank">
              <img src="/icons/instagram.png" alt="Instagram" class="social-img" />
            </a>
          </div>
          <div class="copyright-text">© 2024 Sanعa. All rights reserved.</div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'

const router = useRouter()
const $q = useQuasar()

const showNotifications = ref(false)

const notifications = ref([])

const unreadCount = computed(() => notifications.value.filter((n) => !n.read).length)

const markAsRead = (index) => {
  notifications.value[index].read = true
}

const acceptOffer = (index) => {
  const notif = notifications.value[index]
  $q.notify({ type: 'positive', message: `Accepted offer from ${notif.fixerName}` })
  notifications.value.splice(index, 1)
}

const declineOffer = (index) => {
  const notif = notifications.value[index]
  $q.notify({ type: 'warning', message: `Declined offer from ${notif.fixerName}` })
  notifications.value.splice(index, 1)
}

const goToPage = (route) => {
  if (route) router.push(route)
}

const items = ref([
  { label: 'Plumbing', icon: '/icons/plumbing.png', route: '/plumbing' },
  { label: 'Carpentery', icon: '/icons/carpentry.png', route: '/carpentry' },
  { label: 'Electrical', icon: '/icons/electrical.png', route: '/electrical' },
  { label: 'Kitchen Utilities', icon: '/icons/kitchen.png', route: '/kitchen' },
  { label: 'Painters and Decorators', icon: '/icons/painters.png', route: '/painters' },
  { label: 'Drapery Seamstress', icon: '/icons/drapery.png', route: '/drapery' },
])
</script>

<style scoped>
.home-grid {
  width: 100%;
  max-width: 960px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  justify-items: center;
  margin-top: 100px;
}

.grid-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  cursor: pointer;
}

.icon-box {
  width: 96px;
  height: 96px;
  border-radius: 12px;
  background: #f5f5f7;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-box img {
  max-width: 64px;
  max-height: 64px;
}

.label {
  margin-top: 10px;
  font-size: 14px;
  text-align: center;
}

.footer-area {
  width: 100%;
  max-width: 960px;
  margin-top: 60px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.icon-buttons {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 32px;
  padding: 8px 0;
}

.social-img {
  width: 40px;
  height: 40px;
  object-fit: contain;
  transition:
    transform 0.2s ease,
    filter 0.5s ease;
}

.social-img:hover {
  transform: scale(1.15);
}

.copyright-text {
  font-size: 12px;
  color: #888;
  text-align: center;
}
</style>
