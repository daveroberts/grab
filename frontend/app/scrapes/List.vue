<template>
  <div>
    <h1>Scrapes</h1>
    <v-btn fab right absolute color="primary" href="/#/scrapes/new"><v-icon>add</v-icon></v-btn>
    <div v-if="!scrapes">
      Loading...
    </div>
    <div v-else>
      <table class="table">
        <thead>
          <tr>
            <td>Name</td>
          </tr>
        </thead>
        <tbody>
          <tr v-for="scrape in scrapes">
            <td>
              <a :href="'/#/scrapes/'+scrape.id" @click="set_scrape(scrape)">{{scrape.name}}</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
export default {
  computed: {
    scrapes(){ return state.scrapes.data }
  },
  created: function(){
    fetch(`/api/scrapes/`, {
      credentials: 'include'
    }).then(res => {
      if (res.ok){ return res.json() }
    }).then(scrapes => {
      state.scrapes.data = scrapes
      state.scrapes.last_loaded = Date.now()
    }).catch(err => {
      console.log(err)
    })
  },
  data: function(){
    return {
      state: state,
      SETTINGS: SETTINGS
    }
  },
  methods: {
    set_scrape(scrape){
      state.current.scrape = scrape
    }
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
