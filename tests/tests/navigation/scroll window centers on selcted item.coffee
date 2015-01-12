require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Scroll window centers on selected item": (browser) ->
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
      .verify.hidden(ns + combo_list, "list should have 'closed'")
      .openComboList(ns)
      .verify.scrollVerticalNotVisible(ns + combo_list, first_item)
      .assert.scrollVerticalVisible(ns + combo_list, active_item)
      .end()