<template>
  <div>
    <!--v-btn left absolute color="orange darken-3 white--text" @click.prevent="debug()">DEBUG</v-btn-->
    <div v-if="!scrape">
      Loading...
    </div>
    <div v-else>
      <v-btn right absolute color="primary" @click.prevent="save()">
        <v-icon style="margin-right: 0.5em;">cloud</v-icon>Save
      </v-btn>
      <h1>Scrape Editor</h1>
      <v-text-field label="Scrape Name" v-model="scrape.name"></v-text-field>
      <v-text-field @paste="paste_url" label="URL" v-model="scrape.url"></v-text-field>
      <div v-if="!current_run.link">
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
                    <v-btn color="green darken-4 white--text" small @click.prevent="state.current.run.link = link; test_link()" fab>
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
      </div> <!-- div current_run.link -->
      <div style="margin: 1em 0" v-if="current_run.link">
        <span class="title">
          Testing with <a target="_blank" :href="current_run.link">{{current_run.link}}</a>
          <v-btn small color="error white--text" @click.prevent="current_run.link = null; current_run.test_page = null">Change link</v-btn>
        </span>
        <v-progress-linear v-show="waiting.for_link" :indeterminate="true"></v-progress-linear>
        <div v-if="current_run.test_page">
          <div style="margin: auto; width: 400px;">
            <a target="_blank" :href="'/api/images/'+current_run.test_page.image_id">
              <img class="thumbnail" :src="'/api/images/'+current_run.test_page.image_id+'/thumbnail/'" alt="retrieved image from website" />
            </a>
          </div>
          <table class="mappings_table">
            <thead>
              <tr>
                <th style="width: 10em">Label</th>
                <th style="width: 15em">Mapping</th>
                <th>Result</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="mapping in scrape.mappings">
                <td>
                  <v-text-field label="Label" v-model="mapping.label"></v-text-field>
                </td>
                <td>
                  <v-text-field label="CSS" v-model="mapping.css"></v-text-field>
                </td>
                <td>
                  <div v-if="css_match(mapping.css, current_run.test_page.html) != null">
                    <pre style="white-space: pre-wrap; max-height: 20em; overflow-y: auto;">{{css_match(mapping.css, current_run.test_page.html)}}</pre>
                  </div>
                  <div v-else>
                    Selector not found on test page
                  </div>
                </td>
                <td><v-btn @click.prevent="remove_mapping(mapping)" fab color="error" small><v-icon>delete</v-icon></v-btn></td>
              </tr>
              <tr>
                <td colspan="4">
                  <v-btn small color="primary" @click.prevent="scrape.mappings.push({label: '', css:''})">Add Mapping</v-btn>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="mapping">
            <div v-if="matched_text">
              <div>Matched Text</div>
              <pre style="white-space: pre-wrap">{{matched_text}}</pre>
            </div>
            <div v-else>
              <span class="error--text">Did not match any CSS selector!</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import initial from '../state/initial.js'
import state from '../state/state.js'
import * as senate from '../state'
import cheerio from 'cheerio'
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
    if (this.$route.params.id == 'new'){
      state.current.scrape = {
        id: null,
        name: '',
        url: '',
        pattern: '',
        mappings: [],
        created_at: null
      }
      state.current.run = JSON.parse(JSON.stringify(initial.current.run))
    } else if (!state.current.scrape || state.current.scrape.id != this.$route.params.id) {
      state.current.scrape = null
      load_scrape(this.$route.params.id)
    }
  },
  data: function(){
    return {
      state: state,
      mapping: "",
      waiting: {
        for_links: false,
        for_link: false,
      },
      show_unmatching_links: false,
      SETTINGS: SETTINGS
    }
  },
  methods: {
    debug(){
      this.$router.replace(`/scrapes/${9999}`)
    },
    css_match(css, html){
      const $ = cheerio.load(state.current.run.test_page.html)
      var match = $(css).text()
      if (match){
        match = match.replace(/  +/g, ' ')
        match = match.replace(/((\r\n|\r|\n)\s*)+/g, "\n")
        return match.trim()
      } else {
        return null
      }
    },
    remove_mapping(mapping){
      var idx = scrape.mappings.find_index(mapping)
      if (idx > -1){ scrape.mappings.splice(idx, 1) }
    },
    save(){
      var self = this
      fetch(`/api/scrapes/`, {
        credentials: 'include',
        method: 'POST',
        body: JSON.stringify(state.current.scrape)
      }).then(res => {
        if (res.ok){ return res.json() }
      }).then(body => {
        state.current.scrape = body.scrape
        self.$router.replace(`/scrapes/${body.scrape.id}`)
        senate.flash("Scrape saved")
      }).catch(err => {
        senate.flash("Error saving scrape", "error")
        console.log(err)
      })
    },
    paste_url(e){
      var clipboard_data = e.clipboardData || window.clipboardData
      var url = clipboard_data.getData('Text')
      this.get_links(url)
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
    test_link(){
      var self = this
      self.waiting.for_link = true
      state.current.run.test_page = null
      fetch(`/api/run/link`, {
        credentials: 'include',
        method: 'POST',
        body: JSON.stringify({url: state.current.run.link})
      }).then(res => {
        self.waiting.for_link = false
        if (res.ok){ return res.json() }
      }).then(test_page => {
        state.current.run.test_page = test_page
      }).catch(err => {
        console.log(err)
        self.waiting.for_link = false
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
.thumbnail{ border: 5px solid grey; }
.mappings_table{ border-spacing: 0.5em; border-collapse: separate; }
.mappings_table tr{ border-bottom: 2px solid #ccc; }
</style>
