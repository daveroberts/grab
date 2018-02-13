<template>
  <div>
    <div v-if="!scrape">
      Loading...
    </div>
    <div v-else>
      <div v-if="!editing.name">
        <h2>{{scrape.name || 'Untitled Scrape'}} <a href="#" @click.prevent="editing.name = true"><i class="fa fa-pencil" aria-hidden="true"></i></a></h2>
      </div>
      <div v-else style="width: 30em;">
        <input style="width: 100%; box-sizing: border-box;" class="form_input large" type="text" v-model="scrape.name" />
        <div style=" text-align: right; margin: 0.5em 0;">
          <button @click.prevent="editing.name = false" class="btn">Cancel</button>
          <button @click.prevent="editing.name = false" class="btn btn-main">Save</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
const load_scrape = (id) => {
  fetch(`/api/scrapes/${id}`, {
    credentials: 'include'
  }).then(res => {
    if (res.ok){ return res.json() }
  }).then(scrape => {
    state.current.scrape = scrape
  }).catch(err => {
    console.log(err)
  })
}
export default {
  computed: {
    scrape(){ return state.current.scrape }
  },
  created: function(){
    if (!state.current.scrape || state.current.scrape.id != this.$route.params.id) {
      state.current.scrape = null
      load_scrape(this.$route.params.id)
    }
  },
  data: function(){
    return {
      state: state,
      editing: {
        name: false
      },
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
