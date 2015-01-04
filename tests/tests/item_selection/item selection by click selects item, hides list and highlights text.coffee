require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Item selection by click selects item, hides list and highlights text": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select")
      .openComboList(ns)
      .assert.value(ns + combo_input, "my special number is 0.621")
      .assert.selectedText(ns + combo_input, "my special number is 0.621")
      .end()