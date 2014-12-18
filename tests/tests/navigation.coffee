require('../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "On DOWN/UP active item moves one item": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)

    for i in [1..21]
      browser
        .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
        .pause(10)

    browser
      .assert.cssClassPresent(ns + "li:nth-child(#{21})", 'active')
      .assert.cssClassNotPresent(ns + "li:nth-child(#{21+1})", 'active')

    for i in [1..11]
      browser
        .setValue(ns + combo_input, browser.Keys.UP_ARROW)
        .pause(10)

    browser
      .assert.cssClassPresent(ns + "li:nth-child(#{21-11})", 'active')
      .assert.cssClassNotPresent(ns + "li:nth-child(#{21-11+1})", 'active')
      .end()

  "On PAGEDOWN/PAGEUP active item moves one item": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)

    pageskip = 10

    for i in [1..3]
      browser
        .setValue(ns + combo_input, browser.Keys.PAGEDOWN)
        .pause(10)
        .assert.cssClassPresent(ns + "li:nth-child(#{i*pageskip+1})", 'active', "the #{i*pageskip+1}th item is active")
        .assert.cssClassNotPresent(ns + "li:nth-child(#{i*pageskip+2})", 'active', "the #{i*pageskip+2}th item is not active")

    i = 3*pageskip+1
    for j in [1..2]
      browser
        .setValue(ns + combo_input, browser.Keys.PAGEUP)
        .pause(10)
        .assert.cssClassPresent(ns + "li:nth-child(#{i - j*pageskip})", 'active', "the #{i - j*pageskip}th item is active")
        .assert.cssClassNotPresent(ns + "li:nth-child(#{i - j*pageskip+1})", 'active', "the #{i - j*pageskip}th item is not active")

    browser.end()

  "On HOME/END active item moves to ends of list": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)

      .setValue(ns + combo_input, browser.Keys.END)
      .pause(10)
      .assert.cssClassPresent(ns + "li:nth-child(1275)", 'active', "the 1275th item is active")
      .assert.cssClassNotPresent(ns + "li:nth-child(1274)", 'active', "the 1274th item is not active")

      .setValue(ns + combo_input, browser.Keys.HOME)
      .pause(10)
      .assert.cssClassPresent(ns + "li:nth-child(1)", 'active', "the 1th item is active")
      .assert.cssClassNotPresent(ns + "li:nth-child(2)", 'active', "the 2th item is not active")

      .end()

  "scroll window centers on selcted item": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)

    for i in [0..21]
      browser
        .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
        .pause(10)

    browser
      .assert.cssClassPresent(ns + "li.active", 'enabled')
      .click(ns + "li.active")
      .pause(100)
      .verify.cssProperty(ns + combo_list, 'max-height', "0px", "list should have 'closed'")
      .pause(100)
      .openComboList(ns)
      .verify.scrollVerticalNotVisible(ns + combo_list, first_item)
      .assert.scrollVerticalVisible(ns + combo_list, active_item)
      .end()



# require("../testUtils.js").run_only(module, -2)
