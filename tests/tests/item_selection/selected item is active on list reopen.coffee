require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Selected item is active on list reopen": (browser) ->
    browser
      .setupCombo()
      .openComboList(ns)
      .click(ns + second_item)
      .openComboList(ns)
      .assert.cssClassPresent(ns + second_item, "active")
      .end()