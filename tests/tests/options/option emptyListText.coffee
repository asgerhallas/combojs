require('../../testutils.js').plug_macros()
data = []

ns = "#temp_combo "
module.exports =
  "Option emptyListText: default=(ingen valgmuligheder)": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)

      .openComboList(ns)
      .assert.containsText(ns+empty_list, "(ingen valgmuligheder)")
      .end()

  "Option keepListOpen: 'hello world!'": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {emptyListText: "hello world!"})

      .openComboList(ns)
      .assert.containsText(ns+empty_list, "hello world!")
      .end()
