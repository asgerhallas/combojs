require('../testutils.js').setup_macros()

ns = ns_1275

module.exports =
    # "On button click, visiblity of empty list is toggled": (browser) -> browser.assert.ok(false)
    # "On button click, visiblity of nonempty list is togled": (browser) -> browser.assert.ok(false)
    # "On keypress, visiblity of empty list is toggled": (browser) -> browser.assert.ok(false)
    # "On keypress, visibility of nonempty list is toggled": (browser) -> browser.assert.ok(false)
    # "On enabled item click, list is hidden": (browser) -> browser.assert.ok(false)
    # "On disabled item click, list is not hidden": (browser) -> browser.assert.ok(false)

    "Hotkeys UP/DOWN/Ascii display list": (browser) ->
      k = browser.Keys
      for key in ["DOWN_ARROW", "UP_ARROW", "Arbitrary key sequence"]
        browser
          .setup()
          .waitForElementNotVisible(ns + combo_list)
          .click(ns + combo_input)
          .pause(10)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementVisible(ns + combo_list, "list should be visible after #{key} is pressed")
      browser.end()

    "Hotkeys ESCAPE/ENTER/TAB hides list if active item is enabled": (browser) ->
      k = browser.Keys
      for key in ["ESCAPE", "ENTER", "TAB"]
        browser
          .setup()
          .click(ns + combo_input)
          .pause(10)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # disabled item (different behavior)
          .setValue(ns + combo_input, browser.Keys.DOWN_ARROW) # enabled item
          .waitForElementVisible(ns + combo_list)
          .pause(10)
          .setValue(ns + combo_input, browser.Keys[key])
          .waitForElementNotVisible(ns + combo_list, "list should be hidden after #{key} is pressed")
      browser.end()

    # "On RightKey, display list": (browser) -> browser.assert.ok(false)
    # "On LeftKey, display list": (browser) -> browser.assert.ok(false)
    # "On EscKey, hide list": (browser) -> browser.assert.ok(false)
    # "On DeleteKey and BackspaceKey, list is not opend": (browser) -> browser.assert.ok(false)

require("../testUtils.js").run_only(module, -1)
