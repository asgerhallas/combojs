require('../../testutils.js').plug_macros()

ns = ns_1275
module.exports =

    "Setup": (browser) ->
        browser
            .setupCombo()

    "Open combo-list by button click": (browser) ->
        browser
            .moveToElement('css selector', ns + combo_input, 535, 5)
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
            .moveToElement('css selector', ns + combo_list, 535, 200)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()

            .moveToElement('css selector', ns + combo_list, 535, 200)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()

            .moveToElement('css selector', ns + combo_list, 535, 200)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()

            .moveToElement('css selector', ns + combo_list, 535, 200)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()

            .moveToElement('css selector', ns + combo_list, 535, 200)
            .pause(100)
            .mouseButtonDown()
            .mouseButtonUp()

            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages up by clicking on scrollbar": (browser) ->
        browser
            .moveToElement('css selector', ns + combo_list, 535, 20)
            .pause(1000)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(1000)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(1000)
            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages down by clicking on button": (browser) ->
        browser
            .moveToElement('css selector', ns + combo_list, 535, 298)
            .pause(1000)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(1000)
            .mouseButtonDown()
            .mouseButtonUp()
            .pause(1000)
            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Move two pages up by clicking on button": (browser) ->
        browser
            .moveToElement('css selector', ns + combo_list, 535, 2)
            .pause(1000)

            .mouseButtonDown()
            .mouseButtonUp()
            .pause(1000).mouseButtonDown()
            .mouseButtonUp()
            .pause(1000)

            .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')
            .pause(2000)

    "Check scroll window position": (browser) ->
        # firefox scroll click moves +2 items more than ie, chrome
        for i in [30..34]
            browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")
        for i in [36..48]
            browser.verify.scrollVerticalVisible(ns + combo_list, "li:nth-child(#{i})")
        for i in [51..53]
            browser.verify.scrollVerticalNotVisible(ns + combo_list, "li:nth-child(#{i})")

    "Check input field content": (browser) ->
        browser
            .assert.value(ns + combo_input, "f")
            .end()