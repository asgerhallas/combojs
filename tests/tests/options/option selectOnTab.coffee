require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =
  # selectOnTab selects item -> toggles class active,
  # hides list and highlights input text

  "Option selectOnTab: default=enabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)

      .openComboList(ns)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns + combo_input, browser.Keys.TAB)
      .waitForElementNotVisible(ns+combo_list)

      .openComboList(ns)
      .assert.cssClassPresent(ns + first_item, 'active')
      .assert.value(ns + combo_input, "1")
      .assert.selectedText(ns + combo_input, "1")

      .end()

  "Option selectOnTab: disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {selectOnTab: false})

      .openComboList(ns)
      .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns + combo_input, browser.Keys.TAB)

      .waitForElementNotVisible(ns+combo_list)
      .assert.cssClassPresent(ns + first_item, 'active')
      .assert.value(ns + combo_input, "")
      .assert.selectedText(ns + combo_input, "")

      .end()