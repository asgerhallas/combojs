require('../../testutils.js').plug_macros()

module.exports =
  "Item click hides non-empty list": (browser)->
    ns = ns_1275

    browser
      .setupCombo()
      .click(ns + combo_button)
      .waitForElementVisible(ns + combo_list)
      .click(ns + second_item)
      .waitForElementNotVisible(
        ns + combo_list,
        browser.globals.waitForConditionTimeout,
        false, null,
        "#{ns}: list should be hidden after item click")
      .end()