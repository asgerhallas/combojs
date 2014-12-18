require('../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "item selection by click selects item, hides list and highlights text": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select")
      .openComboList(ns)
      .assert.value(ns + combo_input, "my special number is 0.621")
      .assert.selectedText(ns + combo_input, "my special number is 0.621")
      .end()

  "item selection by ENTER/TAB selects active item, hide list and highlights text": (browser) ->
    browser.setupCombo()
    for key in ["ENTER", "TAB"]
      browser
        .refresh()
        .openComboList(ns)
        .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
        .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
        .setValue(ns + combo_input, browser.Keys[key])
        .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select by #{key}")
        .assert.cssClassPresent(ns + second_item, 'active')
        .assert.value(ns + combo_input, "my special number is 0.621", "should contain selected text")
        .verify.selectedText(ns + combo_input, "my special number is 0.621")
    browser.end()

  "disabled item cannot be selected": (browser) ->
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

  "selected item is active on list reopen": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .openComboList(ns)
      .assert.cssClassPresent(ns + second_item, "active")
      .end()

  "html tags are ignored wrt. selection text": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "truly")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "I <em><b>truly</b></em> believe you are special! <strike>#2</strike>")
      .click(ns + combo_list + "li:nth-child(2)")
      .assert.value(ns + combo_input, "I truly believe you are special! #2")
      .end()

# require("../testUtils.js").run_only(module, -1)
