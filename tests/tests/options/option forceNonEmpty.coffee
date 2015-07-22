utils = require('../../testutils.js')
utils.plug_macros()

data = ({ id: i, text: "#{i}" } for i in ["A","B","C","D"])

ns = "#temp_combo "
module.exports =

  tags: ['forceNonEmpty']

  "Option forceNonEmpty: default=false, initial value eql ''": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceNonEmpty: false })
      .assert.value(ns + combo_input, "")
      .end()

  "Option forceNonEmpty: true, initial value eql first of source": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceNonEmpty: true })
      .assert.value(ns + combo_input, "A")
      .end()

  "Option forceNonEmpty: default=false, blur and value='', value does not change": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceNonEmpty: false })
      .setValue(ns + combo_input, "")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "")
      .end()

  "Option forceNonEmpty: true, blur and value='', revert to prev nonempty value": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceNonEmpty: true })
      .setValue(ns + combo_input, "")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "A")
      .end()

  "Option forceNonEmpty: default=false, does not throw error": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, [], { forceNonEmpty: false }, false)
      .end()

  "Option forceNonEmpty: true, throw error": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, [], { forceNonEmpty: true }, true)
      .end()