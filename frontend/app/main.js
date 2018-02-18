//import './styles/reset.css'
//import './styles/style.less'

import Vue from 'vue'
import Vuetify from 'vuetify'
Vue.use(Vuetify, {
  theme: {
    primary: '#0D47A1', /* #0D47A1 */
    secondary: '#AAAAAA', /* #AAAAAA */
    error: '#a73131', /* #a73131 */
    /*accent: '#00FFFF',*/
    /*error: '#00FFFF'*/
  }
})
import 'vuetify/dist/vuetify.min.css'

import router from './Router.js'
import App from './App.vue'

var app = new Vue({
  el: '#app',
  render: h=>h(App),
  router: router
})
