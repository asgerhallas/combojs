require('../testutils').plug_macros()

module.exports.command = (ns, data, options, comboId="last") ->
  prefix = ns.slice(0,1)
  suffix = ns.slice(1).trim()

  @assert.equal(prefix, "#", "namespace should start with #")
  @.execute(newComboElement, [suffix, data, options, comboId], done)
   .waitForElementVisible(ns + combo_input, "Element<#{ns + combo_input}> is visible")

#====================================================
# SUBROUTINES
#====================================================
newComboElement = (id, data, options, comboId) ->
    $("<div id='#{id}'>")
        .append("<h3>Temp container: #{id}</h3>")
        .append("<div id='inner-#{id}'></div>")
        .append('<br />')
        .appendTo('body')

    combo = new Combo(options)
    combo.load(data)
    combo.appendTo("#inner-#{id}")
    combo.renderFullList()
    window.temp = window.temp || {}
    window.temp[comboId] = combo

done = (result) ->
  console.log result.value.localizedMessage unless result.status is 0
  @assert.ok result.status is 0, "status ok?"
#====================================================