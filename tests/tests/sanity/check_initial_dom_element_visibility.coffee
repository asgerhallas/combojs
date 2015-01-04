require('../../testutils.js').plug_macros()

module.exports =

  "Check initial dom element visibility": (browser) ->
    browser.setupCombo()

    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .assert.visible(ns + combo_button)
        .assert.hidden(ns + combo_list)
        .assert.visible(ns + combo_input)

    browser.end()