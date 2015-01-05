require('../testutils').plug_macros()

module.exports.command = (ns, data, options) ->
  prefix = ns.slice(0,1)
  suffix = ns.slice(1).trim()

  @assert.equal(prefix, "#", "namespace should start with #")
  @.execute(newComboElement, [suffix, data, options], done)
   .waitForElementVisible(ns + combo_input, "Element<#{ns + combo_input}> is visible")

#====================================================
# SUBROUTINES
#====================================================
newComboElement = require('../testutils').newComboElement

done = (result) ->
  console.log result.value.localizedMessage unless result.status is 0
  @assert.ok result.status is 0, "status ok?"
#====================================================