require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Filter is whitespace insensitive": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "    Massiv     100        Bindingsværk  ")
      .verify.numberOfChildren(ns+"li", 2)
      .verify.innerHTML(ns + combo_list + "li:nth-child(1)", "<b>Massiv</b> ydervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.34)")
      .verify.innerHTML(ns + combo_list + "li:nth-child(2)", "<b>Massiv</b> indervæg, <b>Bindingsværk</b>, <b>100</b> mm.  (U: 0.39)")
      .end()