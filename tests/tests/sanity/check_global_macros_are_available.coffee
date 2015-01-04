require('../../testutils.js').plug_macros()

module.exports =

  "Check global macros are available": (browser) ->
    browser.assert.ok(combo_button, null, "globals should be loaded")
    browser
      .setupCombo()
      .assert.cssClassPresent(ns_1275 + enabled_item, "enabled")
      .assert.cssClassPresent(ns_1275 + disabled_item, "disabled")
      .end()