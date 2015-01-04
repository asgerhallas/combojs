require('../../testutils.js').plug_macros()

module.exports =

  "Check testdata injection": (browser) ->
    browser
      .setupCombo()
      .assert.numberOfChildren(ns_empty + "li", 0, "#{ns_empty} should be an empty list")
      .assert.numberOfChildren(ns_1275 + "li", 1275, "#{ns_1275} should contain 1275 items")
      .assert.numberOfChildren(ns_10000 + "li", 10000, "#{ns_10000} should contain 10000 items")
      .end()