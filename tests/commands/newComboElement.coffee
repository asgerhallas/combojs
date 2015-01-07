utils = require('../testutils')
utils.plug_macros()

module.exports.command = (ns, data, options) ->
  prefix = ns.slice(0,1)
  suffix = ns.slice(1).trim()

  @assert.equal(prefix, "#", "namespace starts with #")
  @.execute(newComboElement, [suffix, data, options], done)
   .waitForElementVisible(ns + combo_input, "Element<#{ns + combo_input}> is visible")
   .waitForElementPresent(ns + combo_list, "Element<#{ns + combo_list}> is present")

#====================================================
# SUBROUTINES
#====================================================
newComboElement = (ns, data=[], options={}) ->
  el = $("<div id='#{ns}'>")
        .append("<h3>Temp container: #{ns}</h3>")
        .append("<div class='combo_wrapper'></div>")
        .append('<br />')
        .appendTo('body')
        .find(".combo_wrapper")

  el.combo(options)
    .combo('load', data)
    .combo('renderFullList')

done = (result) ->
  console.log result.value.localizedMessage unless result.status is 0
  @assert.ok utils.checkResult(result)
#====================================================