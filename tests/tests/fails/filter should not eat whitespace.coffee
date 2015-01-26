require('../../testutils.js').plug_macros()
data = ({
  id: i
  text: "a aba b",
  true: true
} for i in [1..5])

ns = "#temp_combo "
comboId = "last"

module.exports =
  # ERROR, the seperating space between matches may dissapear

  tags:['uud'],

  "Option matchBy: inText": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'inText' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "aba")
      .verify.innerHTML(ns+combo_list + first_item, "a <b>aba</b> b")

      .end()

  "Option matchBy: firstInText": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'firstInText' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "a")
      .verify.innerHTML(ns+combo_list + first_item, "<b>a</b> aba b")

      .end()

  "Option matchBy: firstInWord": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'firstInWord' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "aba")
      .verify.innerHTML(ns+combo_list + first_item, "a <b>aba</b> b")

      .end()

  "Option matchBy: wholeWord": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'wholeWord' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "aba")
      .verify.innerHTML(ns+combo_list + first_item, "a <b>aba</b> b")

      .end()