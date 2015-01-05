require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "

module.exports =

  "Option expandOnFocus: default=disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .pause(1000)
      .assert.hidden(ns+combo_list)
      .end()

  "Option expandOnFocus: enabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {expandOnFocus: yes})
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .waitForElementVisible(ns+combo_list)
      .end()