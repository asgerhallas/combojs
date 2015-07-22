utils = require('../../testutils.js')
utils.plug_macros()

data = ({ id: i, text: "#{i}" } for i in ["A","B","C","D"])

ns = "#temp_combo "
module.exports =

  tags: ['forceSelectionFromList']

  "Option forceSelectionFromList: default=false, on nonmatching value and blur, does nothing": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceSelectionFromList: false })
      .setValue(ns + combo_input, "X")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "X")
      .end()

  "Option forceSelectionFromList: true, on nonmatching value and blur, revert to lastSelected if lastSelected is null": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceSelectionFromList: true })
      .setValue(ns + combo_input, "X")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "")
      .end()

  "Option forceSelectionFromList: true, does not revert to lastSelected if value is ''": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceSelectionFromList: true })
      .setValue(ns + combo_input, "")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "")
      .end()

  "Option forceSelectionFromList: true, on a nonmatching value and blur, revert to lastSelected if lastSelected is not null": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { forceSelectionFromList: true })
      .setValue(ns + combo_input, "A")
      .click(ns + somewhere_else)
      .setValue(ns + combo_input, "X")
      .click(ns + somewhere_else)
      .assert.value(ns + combo_input, "A")
      .end()