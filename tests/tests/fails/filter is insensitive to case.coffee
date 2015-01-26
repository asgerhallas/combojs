require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  # currently fails becuase case makes a difference

  "Setup": (browser) ->
    browser.setupCombo()

  "Write search term": (browser) ->
    browser
      .click(ns + combo_input)
      .setValue(ns+combo_input, "prefix")

  "Check first result": (browser) ->
      browser
        .assert.numberOfChildren(ns+combo_list+"li", 2)
        .assert.innerHTML(ns + combo_list + "li:nth-child(1)", "<b>Prefix</b>")
        .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "<b>Prefix</b> Suffix")

  "Refresh": (browser) ->
      browser.refresh()

  "Write new search term": (browser) ->
    browser
      .setValue(ns+combo_input, browser.Keys.DELETE)
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix")

  "Check second result": (browser) ->
    browser
      .verify.numberOfChildren(ns+combo_list+"li", 2)
      .verify.innerHTML(ns+combo_list+"li:nth-child(1)", "<b>Prefix</b>")
      .verify.innerHTML(ns+combo_list+"li:nth-child(2)", "<b>Prefix</b> Suffix")

      .end()