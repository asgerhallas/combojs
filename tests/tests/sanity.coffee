require('../testutils.js').setup_macros()

module.exports =

  "Check global macros are available": (browser) ->
    browser.assert.ok(combo_button, null, "globals should be loaded")

  "Check initial dom element visibility": (browser) ->
    browser.setup()
    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .assert.visible(ns + combo_button)
        .assert.hidden(ns + combo_list)
        .assert.visible(ns + combo_input)
    browser.end()

  "Check testdata injection": (browser) ->
    browser
      .setup()
      .assert.numberOfChildren(ns_empty + "li", 0, "should be an empty list")
      .assert.numberOfChildren(ns_1275 + "li", 1275, "should contain 1275 items")
      .assert.numberOfChildren(ns_10000 + "li", 10000, "should contain 10000 items")
      .end()