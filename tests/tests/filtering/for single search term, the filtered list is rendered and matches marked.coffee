require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  "setup": (browser) ->
    browser
    	.setupCombo()
    
	"input search term": (browser) ->
		browser
      		.click(ns + combo_input)
      		.setValue(ns+combo_input, "0.62")

	"check result": (browser) ->
		browser.assert.numberOfChildren(ns+"li", 8)

		for i in [0..7]
			browser.assert.innerHTML(
				ns + combo_list + "li:nth-child(#{i+1})", 
				"my special number is <b>0.62#{i}<b/>")

		browser.end()