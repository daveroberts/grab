<template>
  <div>
    <h1>Scrapes</h1>
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
            <td>{{scrape.name}}</td>
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
    scrapes(){ return state.scrapes }
  },
  created: function(){
    fetch(`/api/scrapes/`, {
      credentials: 'include'
    }).then(res => {
      if (res.ok){ return res.json() }
    }).then(scrapes => {
      state.scrapes = scrapes
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
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
