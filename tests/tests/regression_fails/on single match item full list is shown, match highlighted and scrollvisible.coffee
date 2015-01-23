require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  # currently an error compared to documentation? My special number is 0.621
  # should highlight and show full list if only one item matches

  "On single match item full list is shown, match highlighted and scrollvisible": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix Suffix")
      .assert.numberOfChildren(ns+combo_list+"li", 1275)
      .assert.innerHTML(ns+active_item, "<b>Prefix Suffix</b>")
      .assert.scrollVerticalVisible(ns + combo_list, active_item)
      .end()