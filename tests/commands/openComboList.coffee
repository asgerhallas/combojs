require('../testutils.js').plug_macros()

module.exports.command = (ns) ->
  @
    .waitForElementNotVisible(ns + combo_list)
    .click(ns + combo_button)
    .waitForElementVisible(ns + combo_list)