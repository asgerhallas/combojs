require('../../testutils.js').plug_macros()
ns = ns_1275

module.exports =
    # enter/tab selection does not lead to highlighing

    "Item selection by ENTER selects active item, hide list and highlights text": (browser) ->
        key = "ENTER"

        browser.setupCombo()
            .refresh()
            .openComboList(ns)
            .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
            .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
            .setValue(ns + combo_input, browser.Keys[key])
            .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select by #{key}")
            .verify.cssClassPresent(ns + second_item, 'active')
            .verify.value(ns + combo_input, "my special number is 0.621", "should contain selected text after #{key}")
            .verify.selectedText(ns + combo_input, "my special number is 0.621")
            .end()

    "Item selection by TAB selects active item, hide list and highlights text": (browser) ->
        key = "TAB"

        browser.setupCombo()
            .refresh()
            .openComboList(ns)
            .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
            .setValue(ns + combo_input, browser.Keys.DOWN_ARROW)
            .setValue(ns + combo_input, browser.Keys[key])
            .waitForElementNotVisible(ns + combo_list, "list should be hidden on item select by #{key}")
            .verify.cssClassPresent(ns + second_item, 'active')
            .verify.value(ns + combo_input, "my special number is 0.621", "should contain selected text after #{key}")
            .verify.selectedText(ns + combo_input, "my special number is 0.621")
            .end()