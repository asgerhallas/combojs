utils = require('../testutils')
utils.plug_macros()

module.exports.command = (ns, data=[], options={}, shouldFail=false) ->
  prefix = ns.slice(0,1)
  suffix = ns.slice(1).trim()

  @assert.equal(prefix, "#", "namespace starts with #")
  @assert.equal(ns[ns.length-1], " ", "namespace should end with whitespace char")

  done = (result) -> @assert.ok utils.checkResult(result, shouldFail)

  client = @.execute(newComboElement, [suffix, JSON.stringify(data), JSON.stringify(options)], done)
  if (not shouldFail)
    client
      .waitForElementVisible(ns + combo_input, "Element<#{ns + combo_input}> is visible")
      .waitForElementPresent(ns + combo_list, "Element<#{ns + combo_list}> is present")

#====================================================
# SUBROUTINES
#====================================================
newComboElement = (ns, data, options) ->
  data = JSON.parse(data)
  options = JSON.parse(options)
  
  # functions are not stringified by JSON.stringify
  # must pass the function as a string instead
  if (options.displayField.startsWith("function") || options.displayField.startsWith("("))
    options.displayField = eval(options.displayField)

  if (options.titleField.startsWith("function") ||options.titleField.startsWith("("))
    options.titleField = eval(options.titleField)

  container = $("<div id='#{ns}'>")
        .append("<h3>Temp container: #{ns}</h3>")
        .append('<br />')
        .appendTo('body')

  $("<div class='combo_wrapper'></div>")
    .combo(options)
    .combo('link', data, options?.secondarySource)
    .combo('renderFullList')
    .appendTo(container)


#====================================================