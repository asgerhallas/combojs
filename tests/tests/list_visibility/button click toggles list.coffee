require('../../testutils.js').plug_macros()

module.exports =
  "Button click toggles list for empty list": (browser) ->
    test(browser, ns_empty)

  "Button click toggles list for non-empty list": (browser) ->
    test(browser, ns_1275)


#====================================================
# SUBROUTINES
#====================================================
test = (browser, ns) ->
  timeout = browser.globals.waitForConditionTimeout

  browser
    .setupCombo()
    .pause(100)
    .assert.hidden(ns + combo_list)
    .click(ns + combo_button)
    .waitForElementVisible(ns + combo_list, "#{ns}: list should be visible after click")
    .click(ns + combo_button)
    .waitForElementNotVisible(ns + combo_list, timeout, false, null, "#{ns}: list should be hidden after second click")
    .end()
#====================================================