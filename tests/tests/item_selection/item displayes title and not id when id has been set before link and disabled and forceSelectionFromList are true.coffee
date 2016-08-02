require('../../testutils.js').plug_macros()

data = []
ns = "#temp_combo "

module.exports =
  "item displayes title and not id when disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {disabled: true, forceSelectionFromList: true})
      .execute(
        (container) ->
          combo = $(container).data('combo')
          combo.setValue("This should NOT be the input val")
          combo.link([{ id: "This should NOT be the input val", text: "This should be the input val"}])
          combo.setValue("This should NOT be the input val")
        [ns + combo_container]
      )
      .assert.value(ns + combo_input, "This should be the input val")
      .end()