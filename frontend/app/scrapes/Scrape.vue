<template>
  <div>
    <div v-if="!scrape">
      Loading...
    </div>
    <div v-else>
      <div v-if="editing.name || !scrape.name">
        <form @submit.prevent="editing.name = false">
          <div class="large">
            <label for="name">Site Name: </label>
            <input id="name" ref="name" style="width: 30em; box-sizing: border-box;" class="form_input large" type="text" v-model="scrape.name" />
          </div>
        </form>
      </div>
      <div v-else>
        <h1>{{scrape.name || 'Untitled Scrape'}} <a href="#" @click.prevent="click_edit"><i class="fa fa-pencil" aria-hidden="true"></i></a></h1>
      </div>
      <div v-if="scrape.name">
        <div v-if="editing.url || !scrape.url">
          <form @submit.prevent="editing.url = false">
            <div>
              <label for="url">URL: </label>
              <input id="url" ref="url" style="width: 30em; box-sizing: border-box;" class="form_input" type="text" v-model="scrape.url" />
            </div>
          </form>
        </div>
        <div v-else>
          <h2>{{scrape.url}} <a href="#" @click.prevent="click_url"><i class="fa fa-pencil" aria-hidden="true"></i></a></h2>
        </div>
        <button class="btn" @click.prevent="get_links(scrape.url)">Get Links</button>
        <ul>
          <li v-for="link in current_run.links">{{link}}</li>
        </ul>
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
    scrape(){ return state.current.scrape },
    current_run(){ return state.current.run },
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
        name: false,
        url: false
      },
      SETTINGS: SETTINGS
    }
  },
  methods: {
    get_links(url){
      fetch(`/api/run/links`, {
        credentials: 'include',
        method: 'POST',
        body: JSON.stringify({url})
      }).then(res => {
        if (res.ok){ return res.json() }
      }).then(links => {
        state.current.run.links = links
      }).catch(err => {
        console.log(err)
      })
    },
    click_edit(){
      this.editing.name = true
      this.$nextTick(() => {
        this.$refs.name.focus()
      })
    },
    click_url(){
      this.editing.url = true
      this.$nextTick(() => {
        this.$refs.url.focus()
      })
    },
  }
}
</script>
<style lang="less" scoped>
@import '../styles/variables.less';
</style>
