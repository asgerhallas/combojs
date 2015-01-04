require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "On list reopen, full list is displayed until search terms change": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "Prefix")
      .assert.numberOfChildren(ns+combo_list+"li", 1275)
      .click(somewhere_else)
      .pause(10)
      .openComboList(ns)
      .click(ns + combo_input)
      .setValue(ns+combo_input, " ")
      .assert.numberOfChildren(ns+combo_list+"li", 2)
      .end()