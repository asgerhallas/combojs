require('../../testutils.js').plug_macros()

module.exports =

  "Check global macros are available": (browser) ->
    browser.assert.ok(combo_button, null, "globals should be loaded")
    browser
      .setupCombo()
      .assert.cssClassPresent(ns_1275 + enabled_item, "enabled")
      .assert.cssClassPresent(ns_1275 + disabled_item, "disabled")
      .end()

  "Check initial dom element visibility": (browser) ->
    browser.setupCombo()

    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .assert.visible(ns + combo_button)
        .assert.hidden(ns + combo_list)
        .assert.visible(ns + combo_input)

    browser.end()

  "Check testdata injection": (browser) ->
    browser
      .setupCombo()
      .assert.numberOfChildren(ns_empty + "li", 1, "#{ns_empty} should be the empty list")
      .assert.numberOfChildren(ns_1275 + "li", 1275, "#{ns_1275} should contain 1275 items")
      .assert.numberOfChildren(ns_10000 + "li", 10000, "#{ns_10000} should contain 10000 items")
      .end()