require('../../testutils.js').plug_macros()

module.exports =

  "Key DELETE does not reopen list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      k = browser.Keys
      browser
        .refresh()
        .click(ns + combo_input)
        .setValue(ns + combo_input, "special")
        .click(ns + somewhere_else)
        .click(ns + combo_input) # cursor starts at end of text per default
        .setValue(ns + combo_input, browser.Keys.HOME)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .assert.value(ns+combo_input, "cial")
        .pause(100)
        .assert.hidden(ns + combo_list, "#{ns}: list should remain hidden on delete")
    browser.end()