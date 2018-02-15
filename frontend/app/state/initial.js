const initial_state = {
  loading: false,
  alerts: [
    /*{id: 4, msg: 'success', show: true, type: 'success'},
    {id: 5, msg: 'warning', show: true, type: 'warning'},
    {id: 6, msg: 'danger', show: true, type: 'danger'},*/
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
      html: null
    }
  }
}

export default initial_state
