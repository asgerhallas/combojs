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
        (ns) =>
          combo = $(ns + ".combo_wrapper").data('combo')
          combo.label = () => return {text: "Bob Reggae", className: "foo"}
        [ns]
      )
      .openComboList(ns)
      .assert.containsText('span.foo', "Bob Reggae")
      .click(ns+third_item)
      .assert.containsText('.combo_wrapper > span.foo', "Bob Reggae")
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
        (ns) =>
          combo = $(ns + ".combo_wrapper").data('combo')
          combo.label = (item) => 
            if item?.text is "one" then return {text: "one-label", className: "one"}
            else if item?.text is "two" then return {text: "two-label", className: "two"}
            else if item?.text is "three" then return {text: "three-label", className: "three"}
            null
        [ns]
      )
      # Selecting each element in the list to check if they exist 
      # and renders with the correct text
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent('.combo_wrapper > span.one')
      .assert.containsText('.combo_wrapper > span.one', "one-label")
      .openComboList(ns)
      .click(ns+second_item)
      .waitForElementPresent('.combo_wrapper > span.two')
      .assert.containsText('.combo_wrapper > span.two', "two-label")
      .openComboList(ns)
      .click(ns+third_item)
      .waitForElementPresent('.combo_wrapper > span.three')
      .assert.containsText('.combo_wrapper > span.three', "three-label")
      .end()
