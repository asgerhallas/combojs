require('../../testutils.js').plug_macros()

data = [{ id: "give-me-a-label", text: "foo"}]
ns = "#temp_combo "

module.exports = 
  "Inputlabel updates when selectedItem changes even if text dont change": (browser) ->   
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        (ns) ->
          combo = $(ns + ".combo_wrapper").data('combo')
          combo.label = (item) => if item?.id == "give-me-a-label" then {text: "Bob Reggae", className: "admin-jensen"} else null
        [ns]
      )
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent(".combo_wrapper > span.admin-jensen")
      .execute(
        (ns) ->
          combo = $(ns + ".combo_wrapper").data('combo')
          combo.link([{ id: "someId", text: "foo"}])
          combo.setValue("foo")
        [ns]
      )
      .waitForElementNotPresent(".combo_wrapper > span.admin-jensen") 
    .end()