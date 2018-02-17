<template>
  <v-app>
    <v-navigation-drawer app :value="show_menu">
      <v-toolbar flat color="primary white--text">
        <v-list-tile>
          <v-list-tile-title class="title">
            Application
          </v-list-tile-title>
        </v-list-tile>
      </v-toolbar>
      <v-divider></v-divider>
      <v-list dense class="pt-0">
        <v-list-tile @click="show_menu = false" href="/#/scrapes">
          <v-list-tile-action>
            <v-icon>language</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>
              Scrapes
            </v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar app color="primary white--text">
      <v-toolbar-side-icon color="white--text" @click.prevent="show_menu = !show_menu"></v-toolbar-side-icon>
      <v-toolbar-title>Grab</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-sm-and-down">
        <v-btn @click="show_menu = false" flat color="white" href="/#/scrapes">Scrapes</v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <v-content>
      <v-container fluid>
        <v-speed-dial>I am a speed dial</v-speed-dial>
        <router-view></router-view>
      </v-container>
    </v-content>
    <v-footer app></v-footer>
  </v-app>
  <!--div>
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
  </div-->
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
      show_menu: false,
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
