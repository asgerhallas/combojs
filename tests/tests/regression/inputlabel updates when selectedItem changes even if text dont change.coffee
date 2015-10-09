require('../../testutils.js').plug_macros()

data = [{ id: "give-me-a-label", text: "foo"}]
ns = "#temp_combo "

module.exports = 
  "Inputlabel updates when selectedItem changes even if text dont change": (browser) ->   
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        (container) ->
          combo = $(container).data('combo')
          combo.label = (item) => if item?.id == "give-me-a-label" then {text: "Bob Reggae", className: "admin-jensen"} else null
        [ns + combo_container]
      )
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent(input_label + ".admin-jensen")
      .execute(
        (container) ->
          combo = $(container).data('combo')
          combo.link([{ id: "someId", text: "foo"}])
          combo.setValue("foo")
        [ns + combo_container]
      )
      .waitForElementNotPresent(input_label + ".admin-jensen") 
    .end()