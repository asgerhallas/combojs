require('../testutils.js').plug_macros()
_ = require('underscore')

data = [
  { id: 1, text: "foo", true: yes }
  { id: 2, text: "bar", true: yes }
  { id: 3, text: "bas", true: no }
  { id: 4, text: "baz", true: yes }
  { id: 5, text: "foobar", true: yes }
]

ns = "#temp_combo "

module.exports =
  "Option maxHeight": (browser) ->
    
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .openComboList(ns+" ")
      .assert.cssProperty(ns + combo_container, 'maxHeight', "300px")

      .refresh()
      .setupCombo()
      .newComboElement(ns, data, {maxHeight: 200})
      .openComboList(ns+" ")
      .pause(100)
      .verify.cssProperty(ns + combo_container, 'maxHeight', "200px")
      .end()

  "Option expandOnFocus": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .pause(1000)
      .assert.hidden(ns+combo_list)

      .setupCombo()
      .newComboElement(ns, data, {expandOnFocus: yes})
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .waitForElementVisible(ns+combo_list)
      .end()

  "Option minLength": (browser) ->
    browser.verify.equal(yes, no, "NOT IMPLEMENTED?")
    # browser
    #   .setupCombo()
    #   .newComboElement(ns, data)
    #   .setValue(ns+combo_input, "b")
    #   .assert.numberOfChildren(ns+combo_list+"li", 4)

    #   .setupCombo()
    #   .newComboElement(ns, data, {minLength: 2})
    #   .openComboList(ns+" ")
    #   .setValue(ns+combo_input, 'b')
    #   .verify.numberOfChildren(ns+combo_list+"li", 0)
    #   .setValue(ns+combo_list, 'a')
    #   .verify.numberOfChildren(ns+combo_list+"li", 4)
    #   .setValue(ns+combo_list, 'z')
    #   .verify.numberOfChildren(ns+combo_list+"li", 1)
    #   .end()

  "Option allowEmpty": (browser) ->
    browser.verify.equal(yes, no, "NOT IMPLEMENTED?")

# require("../testUtils.js").run_only(module, -2)
