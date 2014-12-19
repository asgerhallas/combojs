require('../testutils.js').plug_macros()

module.exports =

  "Check global macros are available": (browser) ->
    browser
      .assert.ok(combo_button, null, "globals should be loaded")

    browser
      .setupCombo()
      .assert.cssClassPresent(ns_1275 + enabled_item, "enabled")
      .assert.cssClassPresent(ns_1275 + disabled_item, "disabled")

  "Check initial dom element visibility": (browser) ->
    browser.setupCombo()
    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .verify.visible(ns + combo_button)
        .verify.hidden(ns + combo_list)
        .verify.visible(ns + combo_input)
    browser.end()

  "Check testdata injection": (browser) ->
    browser
      .setupCombo()
      .verify.numberOfChildren(ns_empty + "li", 0, "#{ns_empty} should be an empty list")
      .verify.numberOfChildren(ns_1275 + "li", 1275, "#{ns_1275} should contain 1275 items")
      .verify.numberOfChildren(ns_10000 + "li", 10000, "#{ns_10000} should contain 10000 items")
      .end()

# require("../testUtils.js").run_only(module, -1)
