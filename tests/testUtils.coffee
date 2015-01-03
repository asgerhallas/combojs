module.exports =
    run_only : (module, start, end) ->
        e = module.exports
        ks = Object.keys e
        if not start? then start = ks.length-1
        if not end? then end = start

        fst = if start < 0 then ks.length+start else start
        lst = if end < 0 then ks.length+end else end

        console.log "running narrowed set of set cases: case #{fst} to #{lst}"
        module.exports = {}
        for i in [fst..lst]
          key = ks[i]
          module.exports[key] = e[key]
        e

    plug_macros : () ->
        global.combo_container = "div.combo-list-container "
        global.combo_button = "button.combo-button "
        global.combo_input = "input.combo-input "
        global.combo_list = "ul.combo-list "
        global.first_item = "li:nth-child(1) "
        global.second_item = "li:nth-child(2) "
        global.disabled_item = "li:nth-child(1) "
        global.enabled_item = "li:nth-child(2) "
        global.empty_list = ".empty-list "
        global.somewhere_else = "h3 "

        global.ns_empty = "#empty-list "
        global.ns_1275 = "#medium-list "
        global.ns_10000 = "#large-list "

        global.active_item = "li.active "
        global.selected_item = "li.selected "