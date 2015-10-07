require('../../testutils.js').plug_macros()

data = [{ id: "", text: "foo", enabled: yes }]
ns = "#temp_combo "

module.exports =
  tags: ["SetValueUpdateLabel"]
  
  "Inputlabel updates when selectedItem changes even if text dont change.coffee": (browser) ->   
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        () ->
          combo = $("#temp_combo .combo_wrapper").data('combo')
          combo.label = (item) => if item?.id == "" then {text: "Bob Reggae", className: "admin-jensen"} else null
      )
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent(".combo_wrapper > .admin-jensen")
      .execute(
        () ->
          combo = $("#temp_combo .combo_wrapper").data('combo')
          combo.link([{ id: "someId", text: "foo", enabled: yes }])
          combo.setValue("foo")
      )
      .waitForElementNotPresent(".combo_wrapper > .admin-jensen") 
    .end()