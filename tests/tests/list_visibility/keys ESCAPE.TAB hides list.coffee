require('../../testutils.js').plug_macros()

module.exports =

  "Keys ESCAPE/TAB hides list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      for key in ["ESCAPE", "TAB"]
        browser
          .refresh()
          .pause(100)
          .assert.hidden(ns + combo_list)
          .click(ns + combo_input)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # disabled item (different behavior)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # enabled item
          .waitForElementVisible(ns + combo_list)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementNotVisible(ns + combo_list, "#{ns}: list should be hidden after #{key} is pressed")
    browser.end()