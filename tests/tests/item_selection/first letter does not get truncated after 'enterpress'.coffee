require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  "first letter does not get truncated after 'enterpress'": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys["DOWN_ARROW"])
      .setValue(ns + combo_input, browser.Keys["DOWN_ARROW"])     
      .setValue(ns + combo_input, browser.Keys["ENTER"])
      .setValue(ns+combo_input, "first")
      .assert.value(ns + combo_input, "my special number is 0.621first")
      .end()