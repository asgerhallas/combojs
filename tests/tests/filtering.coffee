require('../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  "Single search term, the filtered list is rendered and matches marked": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "0.62")
      .assert.numberOfChildren(ns+"li", 8)

    for i in [0..7]
      browser.assert.innerHTML(ns + combo_list + "li:nth-child(#{i+1})", "my special number is <b>0.62#{i}<b/>")

    browser.end()

  "Multiple search terms, the filtered list is rendered and matches marked": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Massiv 100 Bindingsværk")
      .assert.numberOfChildren(ns+"li", 2)
      .assert.innerHTML(ns + combo_list + "li:nth-child(1)", "<b>Massiv</b> ydervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.34)")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "<b>Massiv</b> indervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.39)")
      .end()

  "Filter is insensitive to case": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "prefix")
      .assert.numberOfChildren(ns+combo_list+"li", 2)
      .assert.innerHTML(ns + combo_list + "li:nth-child(1)", "<b>Prefix</b>")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "<b>prefix</b> suffix")

      .refresh()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix")

      .assert.numberOfChildren(ns+combo_list+"li", 2)
      .assert.innerHTML(ns+combo_list+"li:nth-child(1)", "<b>Prefix</b>")
      .assert.innerHTML(ns+combo_list+"li:nth-child(2)", "<b>prefix</b> suffix")
      .end()

  "On single match item full list is shown, match highlighted and scrollvisible": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix Suffix")
      .assert.numberOfChildren(ns+combo_list+"li", 1275)
      .assert.innerHTML(ns+active_item, "<b>Prefix suffix</b>")
      .verify.scrollVerticalVisible(ns + combo_list, active_item)
      .end()

  "On list reopen, full list is displayed until search terms change": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix")
      .assert.numberOfChildren(ns+combo_list+"li", 1275)
      .click(somewhere_else)
      .pause(10)
      .openComboList(ns)
      .click(ns + combo_input)
      .setValue(ns+combo_input, " ")
      .assert.numberOfChildren(ns+combo_list+"li", 2)
      .end()

  "Filter is whitespace insensitive": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "    Massiv     100        Bindingsværk  ")
      .assert.numberOfChildren(ns+"li", 2)
      .assert.innerHTML(ns + combo_list + "li:nth-child(1)", "<b>Massiv</b> ydervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.34)")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "<b>Massiv</b> indervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.39)")
      .end()

  "Html tags in items are ignored wrt. to filtering": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)

      .setValue(ns+combo_input, "underline")
      .assert.numberOfChildren(ns+"li", 0, "html tags are ignored in search 1")

      .refresh()
      .setValue(ns+combo_input, "<underline>")
      .assert.numberOfChildren(ns+"li", 0, "html tags are ignored in search 2")

      .refresh()
      .setValue(ns+combo_input, "truly")
      .assert.numberOfChildren(ns+"li", 3, "match terms may be inside tags")
      .assert.innerHTML(ns + combo_list + "li:nth-child(1)", "I <underline><em><b>truly</b></em></underline> believe you are special! <strike>#1</strike>")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "I <em><b>truly</b></em> believe you are special! <strike>#2</strike>")
      .assert.innerHTML(ns + combo_list + "li:nth-child(3)", "I <b>truly</b> <em>believe</em> you are special! #3")
      .end()

# require("../testUtils.js").run_only(module, -1)
