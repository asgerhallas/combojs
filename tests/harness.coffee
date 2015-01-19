    # SUBROUTINES ===================================================
    uuid = (i) ->
      "xxxxxxxx xxxx #{if (i%2 is 0) then 'caramel!' else 'badger!'}xxx yxxx xxxxxxxxxxxx"
        .replace(/[xy]/g, (c) ->
          r = Math.random() * 16 | 0
          v = if c is 'x' then r else (r & 0x3|0x8)
          v.toString(16)
    )

    window.render_container = (id, msg) ->
      $("<div id='#{id}'>")
        .append("<h3>#{msg}</h3>")
        .append("<div id='inner-#{id}' />")
        .append('<br />')
        .appendTo('body')
        .find("#inner-#{id}")

    logEventListener = (list) ->
      (e, data...) =>
        console.log "recieved event", e.type
        list.push({ name: e.type, data: data })

    window.render_combo_setup = (id, msg, data) ->
      list = events["##{id} "] = []
      el = render_container(id, msg)
        .combo({placeholder: "##{id}"})
        .on('loaded', logEventListener(list))
        .on('itemSelect', logEventListener(list))
        .combo('load', data)
        .combo('renderFullList')
        .find('input')

      el.on('enterpress', logEventListener(list))
        .on('leave', logEventListener(list))
        .on('focus', logEventListener(list))
        .on('enter', logEventListener(list))
    # ===============================================================


    # TEST DATA =====================================================
    i = 0
    window.data_1275 = [
      { id: i++, text: "my special number is 0.620", true: no },
      { id: i++, text: "my special number is 0.621", true: yes },
      { id: i++, text: "my special number is 0.622", true: no },
      { id: i++, text: "my special number is 0.623", true: yes },
      { id: i++, text: "my special number is 0.624", true: no },
      { id: i++, text: "my special number is 0.625", true: yes },
      { id: i++, text: "my special number is 0.626", true: no },
      { id: i++, text: "my special number is 0.627", true: yes }
    ]
    window.data_1275.push(id: i++, text: i+":"+uuid(i), true: j%2 isnt 0) for j in [8..1265]
    window.data_1275.push(id: i++, text: text, true: yes) for text in [
        "Massiv væg mod uopvarmet rum, 12 cm tegl, 250 mm udvendig isolering.  (U: 0.14)",
        "Massiv ydervæg, 12 cm tegl, 250 mm udvendig isolering.  (U: 0.14)",
        "Massiv ydervæg, Bindingsværk, 100 mm.  (U: 0.34)",
        "Massiv indervæg, Bindingsværk, 100 mm.  (U: 0.39)",
        "Prefix",
        "Prefix Suffix",
        "I <underline><em>truly</em></underline> believe you are special! <strike>#1</strike>",
        "I <em>truly</em> believe you are special! <strike>#2</strike>",
        "I truly <em>believe</em> you are special! #3"
    ]

    window.data_10000 = (
      {
        id: i
        text: """Hello world,
                 we are legion and my name is mister #{i}
                 and this is my very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 #{if i%2 is 0 then 'caramel!' else 'badger!'}
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 very very very very very very very very
                 long string"""
        true: true
      } for i in [0...10000])
    # ===============================================================