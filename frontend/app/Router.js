import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

import ScrapeList from './scrapes/List.vue'
const routes = [
  { path: '/', component: ScrapeList },
]
const router = new VueRouter({routes})

import state from './state/state.js'

/*
router.beforeEach((to, from, next)=>{
  if (from.path == '/scripts/new' && state.current.script.code){
    var re = /\/scripts\/.+/
    if(re.exec(to.path)){ next(); return; }
    if (confirm("You haven't saved your script, are you sure?")){ next() }
  } else {
    next()
  }
})*/

export default router
