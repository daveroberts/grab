const initial_state = {
  loading: false,
  alerts: [
    /*{id: 4, msg: 'success', show: true, type: 'success'},
    {id: 4, msg: 'info', show: true, type: 'info'},
    {id: 5, msg: 'warning', show: true, type: 'warning'},
    {id: 6, msg: 'error', show: true, type: 'error'},*/
  ],
  scrapes: {
    data: null,
    last_loaded: null
  },
  current: {
    scrape: null,
    run: {
      links: null,
      link: null,
      html: null,
      test_page: null
    }
  }
}

export default initial_state
