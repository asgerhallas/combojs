require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =

  "Option tabIndex: default=null": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {tabIndex: null})
      .assert.attributeEquals(ns + combo_input, 'tabindex', "null")
      .end()

  "Option tabIndex: 12": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {tabIndex: 12})
      .assert.visible(ns+combo_input)
      .assert.attributeEquals(ns + combo_input, 'tabindex', "12")
      .end()