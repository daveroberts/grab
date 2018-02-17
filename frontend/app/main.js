//import './styles/reset.css'
//import './styles/style.less'

import Vue from 'vue'
import Vuetify from 'vuetify'
Vue.use(Vuetify, {
  theme: {
    primary: '#0D47A1', /* #0D47A1 */
    /*secondary: '#FF0000',*/
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
