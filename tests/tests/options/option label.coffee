utils = require('../../testutils.js')
utils.plug_macros()
data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])
ns = "#temp_combo "

module.exports =
  "Option label: () -> {text: Bob Reggae, className: foo})": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        (container) =>
          combo = $(container).data('combo')
          combo.label = () => return {text: "Bob Reggae", className: "foo"}
        [ns + combo_container]
      )
      .openComboList(ns)
      .assert.containsText(first_list_label + '.foo', "Bob Reggae")
      .click(ns+third_item)
      .assert.containsText(input_label + '.foo', "Bob Reggae")
      .end()
      
  "Option label: Can show different variety of labels": (browser) ->
    testData = [
      {text: "one", enabled: yes }, 
      {text: "two", enabled: yes }, 
      {text: "three", enabled: yes }
    ]
    browser
      .setupCombo()
      .newComboElement(ns, testData)
      .execute(
        (container) =>
          combo = $(container).data('combo')
          combo.label = (item) => 
            if item?.text is "one" then return {text: "one-label", className: "one"}
            else if item?.text is "two" then return {text: "two-label", className: "two"}
            else if item?.text is "three" then return {text: "three-label", className: "three"}
            null
        [ns + combo_container]
      )
      # Selecting each element in the list to check if they exist 
      # and renders with the correct text
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent(input_label + '.one')
      .assert.containsText(input_label + '.one', "one-label")
      .openComboList(ns)
      .click(ns+second_item)
      .waitForElementPresent(input_label + '.two')
      .assert.containsText(input_label + '.two', "two-label")
      .openComboList(ns)
      .click(ns+third_item)
      .waitForElementPresent(input_label + '.three')
      .assert.containsText(input_label + '.three', "three-label")
      .end()
