require('../testutils.js').plug_macros()
_ = require('underscore')

ns = ns_1275

done = (result) -> console.log arguments

module.exports =
	"Combo-input focus is stable on tab when multiple combo boxes exist": (browser) ->
		browser.verify.equal(yes, no, "CURRENT BUG, NOT FIXED?")
		
	"When whole match, highlight entire word": 	(browser) ->
		browser.verify.equal(yes, no, "CURRENT BUG, NOT FIXED");

	"Combo box scrollbar standard use does not break functionality?": (browser) ->
		browser 
			.setupCombo()

			# click on button
      		.moveToElement('css selector', ns + combo_input, 510, 5)
      		.mouseButtonDown()
			.mouseButtonUp()
		    .waitForElementVisible(ns + combo_list, 2000, false, null, "combo list should open on button click")

		    .setValue(ns+combo_input, "f")
	        .assert.value(ns + combo_input, "f", "should contain selected text")

		    # buttons are ~18 x 18px, scrollwindow is 520 x 300px

		    # move five pages down by clicking on scrollbar
      		.moveToElement('css selector', ns + ".combo-list", 510, 100)
      		.pause(100)
  			
  			.mouseButtonDown()
			.mouseButtonUp()
      		.pause(100)
			.mouseButtonDown()
			.mouseButtonUp()
			.pause(100)
			.mouseButtonDown()
			.mouseButtonUp()
			.pause(100)
			.mouseButtonDown()
			.mouseButtonUp()
			.pause(100)
			.mouseButtonDown()
			.mouseButtonUp()
      		.pause(100)

			.assert.elementHasFocus(ns + combo_input)
			.pause(2000)

	   		# move two pages up by clicking on scrollbar
      		.moveToElement('css selector', ns + ".combo-list", 510, 25)
      		.pause(100)
      		.mouseButtonDown()
			.mouseButtonUp()
      		.pause(100)
      		.mouseButtonDown()
			.mouseButtonUp()
			.pause(100)
			.assert.elementHasFocus(ns + combo_input)
			.pause(2000)

		    # move two pages down by clicking on button
      		.moveToElement('css selector', ns + ".combo-list", 510, 295)
      		.pause(100)
      		.mouseButtonDown()
			.mouseButtonUp()
      		.pause(100)
      		.mouseButtonDown()
			.mouseButtonUp()
			.pause(100)
			.assert.elementHasFocus(ns + combo_input)
			.pause(2000)

		    # move two page up by clicking on button
      		.moveToElement('css selector', ns + ".combo-list", 510, 5)
      		.pause(100)

			.mouseButtonDown()
			.mouseButtonUp()
			.pause(100).mouseButtonDown()
			.mouseButtonUp()
			.pause(100)

			.assert.elementHasFocus(ns + combo_input)
			.pause(2000)

		for i in [30..34] 
			browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")
		for i in [35..48] 
			browser.verify.scrollVerticalVisible(ns + combo_list, "li:nth-child(#{i})")
		for i in [49..53] 
			browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")

		browser
	        .assert.value(ns + combo_input, "f")
	        .end()


require("../testUtils.js").run_only(module, 1)
