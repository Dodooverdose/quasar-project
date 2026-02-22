<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
      <q-toolbar>
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/0.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
        <q-space /> <q-btn flat round dense icon="account_circle" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <q-page class="flex flex-center">
        <div class="home-grid q-pa-md">
          <div v-for="(item, idx) in items" :key="idx" class="grid-item">
            <div class="icon-box">
              <img :src="item.icon" alt="icon" />
            </div>
            <div class="label">{{ item.label }}</div>
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'

const items = ref([
  { label: 'Profile', icon: '/icons/0.png' },
  { label: 'Requests', icon: '/icons/0.png' },
  { label: 'Messages', icon: '/icons/0.png' },
  { label: 'Bookings', icon: '/icons/0.png' },
  { label: 'Payments', icon: '/icons/0.png' },
  { label: 'Settings', icon: '/icons/0.png' },
  { label: 'Support', icon: '/icons/0.png' },
  { label: 'Reviews', icon: '/icons/0.png' },
  { label: 'More', icon: '/icons/0.png' },
])
</script>

<style scoped>
.home-grid {
  width: 100%;
  max-width: 960px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.grid-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
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
</style>
