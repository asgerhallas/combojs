require('../testutils.js').plug_macros()

module.exports.command = (ns) ->
  @
    .click(ns + combo_button)
    .waitForElementVisible(
    	ns + combo_list, 
    	@globals.waitForConditionTimeout, 
    	false, null, 
    	"Element<#{ns + combo_list}> is visible after button click")