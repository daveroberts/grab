<template>
  <div>
    <div class="nav-bar">
      <router-link class="nav-item" to="/scrapes" exact><i class="fa fa-globe" aria-hidden="true"></i> Scrapes</router-link>
    </div>
    <div v-if="loading" class="loader"></div>
    <div style="padding: 1em;">
      <div id="alerts">
        <div v-for="alert in alerts">
          <div v-bind:class="['alert', `alert-${alert.type}`, alert.show?'visible':'alert-gone']" role="alert">
            {{alert.msg}}
            <a href="#" @click.prevent="close_alert(alert)" class="alert-close"><i class="fa fa-times" aria-hidden="true"></i></a>
          </div>
        </div>
      </div>
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
import state from './state/state.js'
import * as senate from './state'
export default {
  computed: {
    alerts: function(){ return state.alerts },
    loading: function(){ return state.loading }
  },
  created: function(){
  },
  data: function(){
    return {
      state: state,
      SETTINGS: SETTINGS
    }
  },
  methods: {
    close_alert(al){ senate.close_alert(al.id) }
  }
}
</script>
<style lang="less" scoped>
@import './styles/variables.less';
</style>
