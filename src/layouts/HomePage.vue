<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
      <q-toolbar>
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/0.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
        <q-space />
        <q-btn flat round dense icon="account_circle" to="/profile" aria-label="User profile" />
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
        <div class="footer-section">
          <div class="social-icons">
            <div class="icon-buttons">
              <q-btn
                flat
                round
                dense
                icon="facebook"
                size="md"
                style="color: #1877f2"
                href="#"
                target="_blank"
              />
              <q-btn
                flat
                round
                dense
                icon="twitter"
                size="md"
                style="color: #1da1f2"
                href="#"
                target="_blank"
              />
              <q-btn
                flat
                round
                dense
                icon="instagram"
                size="md"
                style="color: #e4405f"
                href="#"
                target="_blank"
              />
            </div>
            <div class="copyright-text">© 2024 Sanعa. All rights reserved.</div>
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'

const items = ref([
  { label: 'Plumbing', icon: '/icons/0.png' },
  { label: 'Carpentery', icon: '/icons/0.png' },
  { label: 'Electrical', icon: '/icons/0.png' },
  { label: 'Kitchen Utilities', icon: '/icons/0.png' },
  { label: 'Painters and Decorators', icon: '/icons/0.png' },
  { label: 'Drapery Seamstress', icon: '/icons/0.png' },
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

.footer-section {
  width: 100%;
  max-width: 960px;
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  margin-top: 150px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  border: 2px solid #4caf50;
}

.social-icons {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background: #fff;
  border-radius: 8px;
  padding: 16px;
}

.icon-buttons {
  display: flex;
  gap: 32px;
  justify-content: center;
  padding: 8px 16px;
}

.copyright-text {
  font-size: 12px;
  color: #888;
  text-align: center;
}
</style>
