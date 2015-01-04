require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

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
