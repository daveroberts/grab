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
        <h1>{{scrape.name || 'Untitled Scrape'}} <v-icon @click.prevent="click_edit">mode_edit</v-icon></h1>
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
        <div v-if="show_link_selection || !current_run.link">
          <v-btn :disabled="waiting.for_links" color="primary white--text" @click.prevent="get_links(scrape.url)">Get Links</v-btn>
          <v-progress-linear v-show="waiting.for_links" :indeterminate="true"></v-progress-linear>
          <div v-if="!waiting.for_links && current_run.links">
            <v-text-field ref="pattern" label="Pattern" v-model="scrape.pattern"></v-text-field>
            <table>
              <thead>
                <tr>
                  <th></th>
                  <th>Matching Links</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="link in matching_links">
                  <td></td>
                  <td>
                    <span class="title">
                      <v-btn color="green darken-4 white--text" small @click.prevent="state.current.run.link = link; show_link_selection = false" fab>
                        <v-icon>keyboard_arrow_right</v-icon>
                      </v-btn>
                      {{link}}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
            <v-checkbox label="Show unmatching links" v-model="show_unmatching_links"></v-checkbox>
            <div v-if="show_unmatching_links">
              <table>
                <thead>
                  <tr>
                    <th></th>
                    <th>Unmatching Links</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="link in unmatching_links">
                    <td></td>
                    <td>{{link}}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div> <!-- waiting for links && current_run.links -->
        </div> <!-- div show_link_selection -->
        <div v-if="current_run.link">
          <v-btn @click.prevent="show_link_selection = true">Test with a different link</v-btn>
          Testing with {{current_run.link}}
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import state from '../state/state.js'
import * as senate from '../state'
const load_scrape = id => {
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
const extract_hostname = url => {
  var hostname
  //find & remove protocol (http, ftp, etc.) and get hostname

  if (url.indexOf("://") > -1) {
    hostname = url.split('/')[2]
  } else {
    hostname = url.split('/')[0]
  }

  //find & remove port number
  hostname = hostname.split(':')[0]
  //find & remove "?"
  hostname = hostname.split('?')[0]

  return hostname
}

export default {
  computed: {
    scrape(){ return state.current.scrape },
    current_run(){ return state.current.run },
    matching_links(){
      if (!state.current.run.links){ return null }
      var links = state.current.run.links.filter((elem, pos, arr) => {
        return arr.indexOf(elem) == pos
      })
      var regex
      try { regex = new RegExp(state.current.scrape.pattern) }
      catch(e){ return [] }
      return links.filter(link => {
        try { return link.match(regex) }
        catch(e){ return false }
      })
    },
    unmatching_links(){
      return state.current.run.links
    },
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
      waiting: {
        for_links: false
      },
      show_unmatching_links: false,
      show_link_selection: true,
      editing: {
        name: false,
        url: false
      },
      SETTINGS: SETTINGS
    }
  },
  methods: {
    debug(){
    },
    get_links(url){
      var self = this
      self.waiting.for_links = true
      fetch(`/api/run/links`, {
        credentials: 'include',
        method: 'POST',
        body: JSON.stringify({url})
      }).then(res => {
        self.waiting.for_links = false
        if (res.ok){ return res.json() }
      }).then(links => {
        state.current.run.links = links
        if (!state.current.scrape.pattern){
          state.current.scrape.pattern = `^https?:\\/\\/${extract_hostname(state.current.scrape.url).split(".").join("\\.")}\\/.*$`
        }
        this.$nextTick(() => { this.$refs.pattern.focus() })
      }).catch(err => {
        console.log(err)
        self.waiting.for_links = false
      })
    },
    click_edit(){
      console.log("Clicked name")
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
