require('../../testutils.js').plug_macros()

module.exports =

  "Item click hides empty list": (browser)->
    test(browser, ns_empty, empty_list)

  "Item click hides non-empty list": (browser)->
    test(browser, ns_1275, second_item)

#====================================================
# SUBROUTINES
#====================================================
test = (browser, ns, itemSelector) ->
  browser
    .setupCombo()
    .click(ns + combo_button)
    .waitForElementVisible(ns + combo_list)
    .click(ns + itemSelector)
    .waitForElementNotVisible(
      ns + combo_list, 
      browser.globals.waitForConditionTimeout, 
      false, null, 
      "#{ns}: list should be hidden after item click")
    .end()

#====================================================
