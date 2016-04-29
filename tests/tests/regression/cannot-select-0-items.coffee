utils = require('../../testutils.js')
utils.plug_macros()

ns = "#custom "
module.exports =

  "cannot select numeric item '0'": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, [0, 1], {titleField: "(item) => item+''"; displayField: "(item) => item+''"})

      .openComboList(ns)
      .click(ns + second_item)     
      .assert.value(ns + combo_input, "1")
      .openComboList(ns)
      .click(ns + first_item)     
      .assert.value(ns + combo_input, "0")
      .end()
  