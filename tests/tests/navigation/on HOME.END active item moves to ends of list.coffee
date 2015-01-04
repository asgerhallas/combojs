require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "On HOME/END active item moves to ends of list": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)

      .setValue(ns + combo_input, browser.Keys.END)
      .pause(10)
      .assert.cssClassPresent(ns + "li:nth-child(1275)", 'active', "the 1275th item is active")
      .assert.cssClassNotPresent(ns + "li:nth-child(1274)", 'active', "the 1274th item is not active")

      .setValue(ns + combo_input, browser.Keys.HOME)
      .pause(10)
      .assert.cssClassPresent(ns + "li:nth-child(1)", 'active', "the 1th item is active")
      .assert.cssClassNotPresent(ns + "li:nth-child(2)", 'active', "the 2th item is not active")

      .end()