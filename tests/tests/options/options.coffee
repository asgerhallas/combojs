require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =
  tags: ['fiii']

  "Option spellcheck: default=disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .openComboList(ns)
      .assert.value(ns+combo_input+"[spellcheck]", "spellcheck", false)
      .end()

  # "Option spellcheck: enabled": (browser) ->
  #   browser
  #     .setupCombo()
  #     .newComboElement(ns, data)
  #     .openComboList(ns)
  #     .assert.value(ns+combo_input, "spellcheck", true)
  #     .end()
