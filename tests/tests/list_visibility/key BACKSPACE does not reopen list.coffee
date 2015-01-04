require('../../testutils.js').plug_macros()

module.exports =

  "Keys BACKSPACE does not reopen list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      k = browser.Keys
      browser
        .refresh()
        .click(ns + combo_input)
        .setValue(ns + combo_input, "special")
        .click(ns + somewhere_else)
        .click(ns + combo_input)
        .setValue(ns + combo_input, browser.Keys.END)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .assert.value(ns+combo_input, "spec")
        .pause(100)
        .assert.hidden(ns + combo_list, "#{ns}: list should remain hidden on backspace")
    browser.end()
