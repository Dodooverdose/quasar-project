<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="fixed-top">
      <q-toolbar>
        <q-toolbar-title style="display: flex; align-items: center">
          Sanعa
          <img src="/icons/White.png" alt="San3a" style="height: 40px; margin-left: 10px" />
        </q-toolbar-title>
        <q-space />
        <q-btn flat round dense icon="notifications" aria-label="Notifications" />
      </q-toolbar>
    </q-header>

    <q-page-container>
      <q-page class="page-content">
        <div v-if="loading" class="state-wrap">
          <q-spinner color="primary" size="48px" />
          <div class="q-mt-md text-grey-7">Loading incoming offers...</div>
        </div>

        <div v-else-if="error" class="state-wrap">
          <q-icon name="error_outline" size="72px" color="negative" />
          <div class="state-title">Could not load offers</div>
          <div class="state-subtitle">{{ error }}</div>
          <q-btn
            unelevated
            color="primary"
            label="Retry"
            icon="refresh"
            rounded
            class="q-mt-md"
            @click="fetchIncomingOffers"
          />
        </div>

        <div v-else-if="incomingOffers.length === 0" class="state-wrap">
          <q-icon name="mark_email_read" size="72px" color="grey-4" />
          <div class="state-title">No incoming offers yet</div>
          <div class="state-subtitle">When a fixer sends a price, it will appear here.</div>
        </div>

        <div v-else class="offers-container">
          <div class="page-title">Incoming Offers</div>
          <div class="row items-center justify-between q-col-gutter-sm q-mb-md">
            <q-badge color="primary" class="q-pa-sm text-body2">
              {{ filteredOffers.length }} {{ filteredOffers.length === 1 ? 'offer' : 'offers' }}
            </q-badge>

            <q-select
              v-model="statusFilter"
              :options="statusFilterOptions"
              emit-value
              map-options
              dense
              outlined
              class="status-filter"
              label="Status"
            />
          </div>

          <div v-if="filteredOffers.length === 0" class="state-wrap state-wrap-inline">
            <q-icon name="filter_alt_off" size="56px" color="grey-4" />
            <div class="state-subtitle">No offers for selected status.</div>
          </div>

          <q-card
            v-for="req in filteredOffers"
            :key="req.request_id"
            flat
            bordered
            class="offer-card q-mb-sm"
          >
            <q-card-section class="q-py-sm">
              <div class="row items-center justify-between q-mb-xs">
                <div class="text-subtitle2 text-weight-bold">Request #{{ req.request_id }}</div>
                <q-badge
                  :color="statusColor(req.request_status)"
                  :label="req.request_status || 'pending'"
                  class="text-capitalize"
                />
              </div>

              <div class="text-body2 text-grey-8 q-mb-sm" style="white-space: pre-line">
                {{ req.description_of_issue || 'No description' }}
              </div>

              <div class="price-row q-mb-sm">
                <q-chip dense color="orange-2" text-color="orange-9" icon="build">
                  Fixer offer: {{ req.fixer_price }} EGP
                </q-chip>
                <q-chip
                  v-if="req.customer_price"
                  dense
                  color="green-2"
                  text-color="green-9"
                  icon="person"
                >
                  Your budget: {{ req.customer_price }} EGP
                </q-chip>
              </div>

              <div v-if="req.fixerInfo" class="fixer-info q-mb-sm">
                <div class="fixer-title">Fixer Details</div>
                <div class="fixer-detail-row">
                  <q-icon name="person" size="14px" color="grey-7" />
                  <span>{{ req.fixerInfo.full_name || 'Unknown fixer' }}</span>
                </div>
                <div v-if="req.fixerInfo.phone_number" class="fixer-detail-row">
                  <q-icon name="phone" size="14px" color="grey-7" />
                  <span>{{ req.fixerInfo.phone_number }}</span>
                </div>
                <div
                  v-if="
                    req.fixerInfo.years_of_experience !== null &&
                    req.fixerInfo.years_of_experience !== undefined
                  "
                  class="fixer-detail-row"
                >
                  <q-icon name="workspace_premium" size="14px" color="grey-7" />
                  <span>{{ req.fixerInfo.years_of_experience }} years of experience</span>
                </div>
              </div>

              <div class="meta-row">
                <div v-if="req.request_date" class="meta-item">
                  <q-icon name="event" size="14px" color="grey-6" />
                  <span>{{ formatDate(req.request_date) }}</span>
                </div>
                <div v-if="req.service_location" class="meta-item">
                  <q-icon name="location_on" size="14px" color="grey-6" />
                  <span>{{ req.service_location }}</span>
                </div>
                <div v-if="req.payment_method" class="meta-item">
                  <q-icon name="payments" size="14px" color="grey-6" />
                  <span class="text-capitalize">{{ req.payment_method }}</span>
                </div>
              </div>
            </q-card-section>
          </q-card>
        </div>
      </q-page>
    </q-page-container>

    <q-footer elevated class="bottom-nav">
      <q-tabs
        v-model="activeTab"
        active-color="white"
        indicator-color="transparent"
        class="nav-tabs"
        narrow-indicator
        dense
      >
        <q-tab name="home" icon="home" label="Home" @click="$router.push('/home')" />
        <q-tab
          name="offers"
          icon="handshake"
          label="Requests"
          @click="$router.push('/incoming-offers')"
        />
        <q-tab name="orders" icon="receipt_long" label="Orders" @click="$router.push('/orders')" />
        <q-tab name="profile" icon="person" label="Profile" @click="$router.push('/profile')" />
      </q-tabs>
    </q-footer>
  </q-layout>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { supabase } from 'src/boot/supabase'

const activeTab = ref('offers')
const loading = ref(true)
const error = ref(null)
const incomingOffers = ref([])
const statusFilter = ref('all')
const statusFilterOptions = [
  { label: 'All', value: 'all' },
  { label: 'Pending', value: 'pending' },
  { label: 'Accepted', value: 'accepted' },
  { label: 'Completed', value: 'completed' },
  { label: 'Cancelled', value: 'cancelled' },
]

const filteredOffers = computed(() => {
  if (statusFilter.value === 'all') {
    return incomingOffers.value
  }
  return incomingOffers.value.filter(
    (r) => (r.request_status || 'pending').toLowerCase() === statusFilter.value,
  )
})

const statusColor = (status) => {
  const map = { pending: 'orange', accepted: 'blue', completed: 'green', cancelled: 'red' }
  return map[status?.toLowerCase()] || 'grey'
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const utcStr = dateStr.endsWith('Z') || dateStr.includes('+') ? dateStr : dateStr + 'Z'
  const d = new Date(utcStr)
  return d.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const fetchIncomingOffers = async () => {
  loading.value = true
  error.value = null

  try {
    const {
      data: { user },
    } = await supabase.auth.getUser()

    if (!user) {
      error.value = 'You must be signed in to view incoming offers.'
      loading.value = false
      return
    }

    const { data: customer } = await supabase
      .from('users')
      .select('user_id')
      .ilike('email', user.email)
      .maybeSingle()

    if (!customer?.user_id) {
      incomingOffers.value = []
      loading.value = false
      return
    }

    const { data, error: fetchErr } = await supabase
      .from('request')
      .select('*')
      .eq('user_id', customer.user_id)
      .not('fixer_price', 'is', null)
      .order('request_date', { ascending: false })

    if (fetchErr) {
      error.value = fetchErr.message
      incomingOffers.value = []
    } else {
      const offers = data || []
      const technicianIds = [...new Set(offers.map((r) => r.technician_id).filter(Boolean))]

      let technicianMap = {}
      if (technicianIds.length) {
        const { data: techRows } = await supabase
          .from('technician')
          .select('technician_id, full_name, phone_number, years_of_experience')
          .in('technician_id', technicianIds)

        technicianMap = (techRows || []).reduce((acc, t) => {
          acc[t.technician_id] = t
          return acc
        }, {})
      }

      incomingOffers.value = offers.map((r) => ({
        ...r,
        fixerInfo: r.technician_id ? technicianMap[r.technician_id] || null : null,
      }))
    }
  } catch (err) {
    error.value = 'An unexpected error occurred.'
    console.error(err)
  } finally {
    loading.value = false
  }
}

onMounted(fetchIncomingOffers)
</script>

<style scoped>
.page-content {
  padding-bottom: 80px;
}

.state-wrap {
  min-height: calc(100vh - 180px);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 24px;
}

.state-title {
  margin-top: 16px;
  font-size: 22px;
  font-weight: 700;
  color: #2e3d36;
}

.state-subtitle {
  margin-top: 8px;
  font-size: 15px;
  color: #90a4ae;
}

.offers-container {
  width: 100%;
  max-width: 540px;
  margin: 0 auto;
  padding: 20px 16px;
}

.status-filter {
  width: 150px;
}

.state-wrap-inline {
  min-height: auto;
  padding: 20px 0 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 800;
  color: #1b5e20;
  margin-bottom: 8px;
}

.offer-card {
  border-radius: 12px !important;
  border-color: #e8eeeb !important;
}

.price-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.meta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #78909c;
}

.fixer-info {
  border: 1px solid #e8eeeb;
  border-radius: 10px;
  padding: 10px 12px;
  background: #fafdfb;
}

.fixer-title {
  font-size: 12px;
  font-weight: 700;
  color: #2e7d32;
  margin-bottom: 6px;
}

.fixer-detail-row {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #455a64;
}

.bottom-nav {
  background: linear-gradient(135deg, #2e7d32, #388e3c) !important;
  box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.12);
}

.nav-tabs {
  height: 60px;
}

.nav-tabs :deep(.q-tab) {
  min-height: 60px;
  font-size: 11px;
  text-transform: none;
  opacity: 0.75;
  transition: opacity 0.2s ease;
}

.nav-tabs :deep(.q-tab--active) {
  opacity: 1;
}

.nav-tabs :deep(.q-tab__icon) {
  font-size: 24px;
}
</style>
