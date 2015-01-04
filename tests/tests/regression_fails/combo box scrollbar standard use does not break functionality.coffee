require('../../testutils.js').plug_macros()

ns = ns_1275
module.exports =

    # scroll window behaves differently in firefox, off by -3/+4

    "Setup": (browser) ->
        browser 
            .setupCombo()

    "Open combo-list by button click": (browser) ->
        browser 
            .moveToElement('css selector', ns + combo_input, 510, 5)
            .mouseButtonDown()
            .mouseButtonUp()
            .waitForElementVisible(ns + combo_list, 2000, false, null, "combo list should open on button click")

    "Write 'f' in input field": (browser) ->
        browser
            .setValue(ns+combo_input, "f")
            .assert.value(ns + combo_input, "f", "should contain selected text")

    "Move five pages down by clicking on scrollbar": (browser) ->
        browser
            # buttons are ~18 x 18px, scrollwindow is 520 x 300px
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

            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages up by clicking on scrollbar": (browser) ->      
        browser
            .moveToElement('css selector', ns + ".combo-list", 510, 25)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(100)
            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages down by clicking on button": (browser) ->
        browser
            .moveToElement('css selector', ns + ".combo-list", 510, 295)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(100)
            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages up by clicking on button": (browser) ->
        browser
            .moveToElement('css selector', ns + ".combo-list", 510, 5)
            .pause(100)

            .mouseButtonDown()
            .mouseButtonUp()
            .pause(100).mouseButtonDown()
            .mouseButtonUp()
            .pause(100)

            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Check scroll window position": (browser) ->
        for i in [30..34] 
            browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")
        for i in [35..48] 
            browser.verify.scrollVerticalVisible(ns + combo_list, "li:nth-child(#{i})")
        for i in [49..53] 
            browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")

    "Check input field content": (browser) ->
        browser
            .assert.value(ns + combo_input, "f")
            .end()