require('../testutils.js').plug_macros()

module.exports.command = (ns) ->
  @
    # .waitForElementNotVisible(ns + combo_list, false, null, "combo list should be hidden before open")
    .click(ns + combo_button)
    .waitForElementVisible(ns + combo_list, 2000, false, null, "combo list should open on click")