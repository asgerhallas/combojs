require('../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "item selection by click selects item and hides list": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select")
      .openComboList(ns)
      .assert.value(ns + combo_input, "my special number is 0.621")
      .assert.numberOfChildren(ns + combo_input, 0)
      .assert.selectedText(ns + combo_input, "my special number is 0.621")
      .end()

  "item selection by enter hides list": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .assert.cssClassPresent(ns + second_item, 'active')
      .setValue(ns + combo_input, browser.Keys.ENTER)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select")
      .assert.value(ns + combo_input, "my special number is 0.621", "should contain selected text")
      # .assert.selectedText(ns + combo_input, "my special number is 0.621")
      .end()

  "disabled item cannot be selected": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .assert.cssClassPresent(ns + disabled_item, 'active')
      .setValue(ns + combo_input, browser.Keys.ENTER)
      .click(ns + disabled_item)
      .pause(100)
      .assert.visible(ns + combo_list, "combo list should remain visible on disabled item select")
      .assert.value(ns + combo_input, "", "no item should have been selected")
      .end()

  'selected item is active on list reopen': (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .openComboList(ns)
      .assert.cssClassPresent(ns + second_item, "active")
      .end()

require("../testUtils.js").run_only(module, -1)
