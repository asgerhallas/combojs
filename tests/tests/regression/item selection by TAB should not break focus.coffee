require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Item selection by TAB should not break focus": (browser) ->

    browser
      .setupCombo()
      .openComboList(ns)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns + combo_input, browser.Keys.TAB)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select by TAB")

    for i in [0..50]
      browser.assert.elementHasFocus(ns + combo_input)

    browser.end()