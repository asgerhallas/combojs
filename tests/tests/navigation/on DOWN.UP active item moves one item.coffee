require('../../testutils.js').plug_macros()

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