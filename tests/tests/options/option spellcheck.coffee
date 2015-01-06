require('../../testutils.js').plug_macros()
data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
comboId = "last"
module.exports =

  "Option spellcheck: default=disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .openComboList(ns)
      .assert.fixedAttributeEquals(ns+combo_input, "spellcheck", "false")
      .end()

  "Option spellcheck: enabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {spellcheck: yes})
      .openComboList(ns)
      .assert.fixedAttributeEquals(ns+combo_input, "spellcheck", "true")
      .end()
