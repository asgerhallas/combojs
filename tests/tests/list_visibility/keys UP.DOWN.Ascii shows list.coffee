require('../../testutils.js').plug_macros()

module.exports =

  "Keys UP/DOWN/Ascii shows list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      for key in ["DOWN_ARROW", "UP_ARROW", "Arbitrary key sequence"]
        browser
          .refresh()
          .pause(100)
          .assert.hidden(ns + combo_list)
          .click(ns + combo_input)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementVisible(ns + combo_list, "#{ns}: list should be visible after #{key} is pressed")
    browser.end()