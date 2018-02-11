import './styles/reset.css'
import './styles/style.less'

import Vue from 'vue'

import router from './Router.js'
import App from './App.vue'

var app = new Vue({
  el: '#app',
  render: h=>h(App),
  router: router
})
