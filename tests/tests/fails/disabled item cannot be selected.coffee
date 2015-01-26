require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  # requires two tabs in firefox

  "Disabled item cannot be selected": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .assert.cssClassPresent(ns + disabled_item, 'active')
      .setValue(ns + combo_input, browser.Keys.ENTER)
      .click(ns + disabled_item)
      .pause(100)
      .assert.visible(ns + combo_list, "combo list should remain visible on disabled item select")
      .assert.value(ns + combo_input, "", "no item should have been selected")
      .setValue(ns + combo_input, browser.Keys.TAB)
      .waitForElementNotVisible(ns + combo_list, "combo list should be hidden on disabled item select by select")
      .assert.value(ns + combo_input, "", "no item should have been selected")
      .end()