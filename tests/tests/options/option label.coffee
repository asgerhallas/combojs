utils = require('../../testutils.js')
utils.plug_macros()
data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['label']

  "Option label: () -> {text: Bob Reggae, className: foo})": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        () =>
          combo = $("#temp_combo .combo_wrapper").data('combo')
          combo.label = () => return {text: "Bob Reggae", className: "foo"})
      .openComboList(ns)
      .assert.containsText('.foo', "Bob Reggae")
      .click(ns+third_item)
      .assert.containsText('.combo_wrapper > .foo', "Bob Reggae")
      .end()
      
  "Option label: Can show different variety of labels": (browser) ->
    testData = [{text: "one", enabled: yes }, {text: "two", enabled: yes }, {text: "three", enabled: yes }]
    browser
      .setupCombo()
      .newComboElement(ns, testData)
      .execute(
        () =>
          combo = $("#temp_combo .combo_wrapper").data('combo')
          combo.label = (item) => 
            if item?.text is "one" then return {text: "one-label", className: "one"}
            else if item?.text is "two" then return {text: "two-label", className: "two"}
            else if item?.text is "three" then return {text: "three-label", className: "three"}
            null
      )
      .openComboList(ns)
      .click(ns+first_item)
      .waitForElementPresent('.combo_wrapper > .one')
      .assert.containsText('.combo_wrapper > .one', "one-label")
      .openComboList(ns)
      .click(ns+second_item)
      .waitForElementPresent('.combo_wrapper > .two')
      .assert.containsText('.combo_wrapper > .two', "two-label")
      .openComboList(ns)
      .click(ns+third_item)
      .waitForElementPresent('.combo_wrapper > .three')
      .assert.containsText('.combo_wrapper > .three', "three-label")
      .end()
