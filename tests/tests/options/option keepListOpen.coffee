require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =

  "Option keepListOpen: default=disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)

      .openComboList(ns)
      .waitForElementVisible(ns+combo_list)
      .click(ns+combo_button)
      .waitForElementNotVisible(ns+combo_list, "item click hides list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + second_item)
      .waitForElementNotVisible(ns + combo_list, "item click hides list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.ESCAPE)
      .waitForElementNotVisible(ns + combo_list, "escape key hides list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.TAB)
      .waitForElementNotVisible(ns + combo_list, "tab key hides list")

      .end()

  "Option keepListOpen: enabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {keepListOpen: true})

      .openComboList(ns)
      .waitForElementVisible(ns+combo_list)
      .click(ns+combo_button)
      .pause(1000)
      .assert.visible(ns+combo_list, "item click does not hide list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + second_item)
      .pause(1000)
      .assert.visible(ns+combo_list, "item click does not hide list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.ESCAPE)
      .pause(1000)
      .assert.visible(ns+combo_list, "escape key does not hide list")

      .openComboList(ns)
      .waitForElementVisible(ns + combo_list)
      .click(ns + combo_input)
      .setValue(ns + combo_input, browser.Keys.TAB)
      .pause(1000)
      .assert.visible(ns+combo_list, "tab key does not hide list")

      .end()
