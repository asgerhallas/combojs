require('../testutils.js').plug_macros()

ns_empty = ns_1275

module.exports =

  "Keys UP/DOWN/Ascii shows list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      for key in ["DOWN_ARROW", "UP_ARROW", "Arbitrary key sequence"]
        browser
          .refresh()
          .pause(100)
          .assert.hidden(ns + combo_list)
          .click(ns + combo_input)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementVisible(ns + combo_list, "#{ns}: list should be visible after #{key} is pressed")
    browser.end()

  "Keys ESCAPE/TAB hides list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      for key in ["ESCAPE", "TAB"]
        browser
          .refresh()
          .pause(100)
          .assert.hidden(ns + combo_list)
          .click(ns + combo_input)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # disabled item (different behavior)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # enabled item
          .waitForElementVisible(ns + combo_list)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementNotVisible(ns + combo_list, "#{ns}: list should be hidden after #{key} is pressed")
    browser.end()

  "Button click toggles list": (browser)->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      browser
        .refresh()
        .pause(100)
        .assert.hidden(ns + combo_list)
        .click(ns + combo_button)
        .waitForElementVisible(ns + combo_list, "#{ns}: list should be visible after click")
        .click(ns + combo_button)
        .waitForElementNotVisible(ns + combo_list, "#{ns}: list should be hidden after second click")
    browser.end()

  "Item click hides list": (browser)->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      browser
        .refresh()
        .click(ns + combo_button)
        .waitForElementVisible(ns + combo_list)
        .click(ns + second_item)
        .waitForElementNotVisible(ns + combo_list, "#{ns}: list should be hidden after item click")
    browser.end()

  "Keys BACKSPACE does not reopen list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      k = browser.Keys
      browser
        .refresh()
        .click(ns + combo_input)
        .setValue(ns + combo_input, "special")
        .click(ns + somewhere_else)
        .click(ns + combo_input)
        .setValue(ns + combo_input, browser.Keys.END)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .setValue(ns + combo_input, browser.Keys.BACK_SPACE)
        .assert.value(ns+combo_input, "spec")
        .pause(100)
        .assert.hidden(ns + combo_list, "#{ns}: list should remain hidden on backspace")
    browser.end()

  "Keys DELETE does not reopen list": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275]
      k = browser.Keys
      browser
        .refresh()
        .click(ns + combo_input)
        .setValue(ns + combo_input, "special")
        .click(ns + somewhere_else)
        .click(ns + combo_input) # cursor starts at end of text per default
        .setValue(ns + combo_input, browser.Keys.HOME)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .setValue(ns + combo_input, browser.Keys.DELETE)
        .assert.value(ns+combo_input, "cial")
        .pause(100)
        .assert.hidden(ns + combo_list, "#{ns}: list should remain hidden on delete")
    browser.end()

  "empty list should have same visibility behavior as nonempty list": (browser) ->
    browser.assert.ok ns_empty isnt ns_1275 # see top of file

require("../testUtils.js").run_only(module, -1)
