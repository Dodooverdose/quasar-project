<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
      <q-toolbar>
        <q-btn flat round dense icon="arrow_back" aria-label="Back to home" @click="goHome" />
        <q-toolbar-title>User Profile</q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <q-page class="profile-page">
        <div class="profile-card">
          <q-btn
            flat
            round
            class="profile-avatar-btn"
            aria-label="Change profile picture"
            @click="openFilePicker"
          >
            <q-avatar size="140px" class="profile-avatar">
              <img :src="avatarUrl" alt="Profile picture" />
            </q-avatar>
          </q-btn>
          <input
            ref="fileInputRef"
            class="visually-hidden"
            type="file"
            accept="image/*"
            @change="onFileChange"
          />

          <div class="profile-actions">
            <q-btn color="secondary" label="Settings" class="action-btn" />
            <q-btn color="negative" label="Log Out" class="action-btn" @click="goToMain" />
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { onBeforeUnmount, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const fileInputRef = ref(null)
const avatarUrl = ref('/icons/0.png')
let objectUrl = null

const openFilePicker = () => {
  fileInputRef.value?.click()
}

const goHome = () => {
  router.push('/home')
}

const goToMain = () => {
  router.push('/')
}

const onFileChange = (event) => {
  const file = event.target.files?.[0]

  if (!file) {
    return
  }

  if (objectUrl) {
    URL.revokeObjectURL(objectUrl)
  }

  objectUrl = URL.createObjectURL(file)
  avatarUrl.value = objectUrl
}

onBeforeUnmount(() => {
  if (objectUrl) {
    URL.revokeObjectURL(objectUrl)
  }
})
</script>

<style scoped>
.profile-page {
  min-height: calc(100vh - 56px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
}

.profile-card {
  width: 100%;
  max-width: 360px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.profile-avatar {
  background: #f5f5f7;
  margin-top: -325px;
}

.profile-avatar-btn {
  padding: 0;
  min-height: unset;
}

.profile-actions {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.action-btn {
  width: 100%;
}

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}
</style>
