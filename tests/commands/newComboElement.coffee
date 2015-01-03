require('../testutils.js').plug_macros()

toExecute = (id, data, options) -> 
	# Refactor, move somewhere else?
	$("<div id='#{id}'>")
		.append("<h3>Temp container: #{id}</h3>")
		.append("<div id='inner-#{id}'></div>")
		.append('<br />')
		.appendTo('body')

	combo = new Combo(options)
	combo.load(data)
	combo.appendTo("#inner-#{id}")
	combo.renderFullList()

done = (result) ->
	@assert.ok result.status is 0, "status ok?"

module.exports.command = (ns, data, options) ->
	prefix = ns.slice(0,1)
	suffix = ns.slice(1).trim()

	@assert.equal(prefix, "#", "namespace should start with #")
	@.execute(toExecute, [suffix, data, options], done)
	 .waitForElementVisible(ns + combo_input, "#{ns + combo_input} should be visible")
