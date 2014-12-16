setup = (browser) ->
  browser
    .url("file:///C:/workspace/combojs/tests/index.html")
    .waitForElementVisible("body")

combo_button = "button.combo-button"
combo_input = "input.combo-input"
combo_list = "ul.combo-list"
first_item = "li:nth-child(1)"
second_item = "li:nth-child(2)"
empty_list = ".empty-list"
somewhere_else = "h3"

ns_empty = "#wrapper-test-1 "
ns_1275 = "#wrapper-test-2 "
ns_10000 = "#wrapper-test-3 "

module.exports =
  "Check initial dom elements visibility": (browser)->
    setup(browser)

    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .assert.visible(ns + combo_button)
        .assert.hidden(ns + combo_list)
        .assert.visible(ns + combo_input)
    browser.end()

  "Testdata is injected": (browser) ->
    setup(browser)
      .assert.numberOfChildren(ns_empty + "li", 0, "should be an empty list")
      .assert.numberOfChildren(ns_1275 + "li", 1275, "should contain 1275 items")
      .assert.numberOfChildren(ns_10000 + "li", 10000, "should contain 10000 items")
      .end()

  "On button click, visibility of empty list is toggled": (browser)->
    setup(browser)

    ns = ns_empty

    browser
      .assert.valueContains(ns+combo_input, "", "input box should be empty")
      .waitForElementNotVisible(ns + empty_list, "list should be hidden before click")
      .click(ns + combo_button)
      .waitForElementVisible(ns + empty_list, "list should be visible after click")
      .click(ns + somewhere_else)
      .waitForElementNotVisible(ns + empty_list, "list should be hidden after second click")
      .assert.valueContains(ns+combo_input, "", "input box should remain empty")
      .end()

  "On button click, visiblity of nonempty list is toggled": (browser)->
    setup(browser)

    ns = ns_1275

    browser
      .waitForElementNotVisible(ns + combo_list, "list should be hidden before click")
      .click(ns + combo_button)
      .waitForElementVisible(ns + combo_list, "list should be visible after click")
      .click(ns + combo_button)
      .waitForElementNotVisible(ns + combo_list, "list should be hidden after second click")
      .assert.valueContains(ns+combo_input, "", "input box should be empty")
      .end()

  "On keypress, visibility of empty list is toggled": (browser)->
    setup(browser)

    ns = ns_empty

    browser
      .click(ns+combo_input)
      .setValue(ns+combo_input, "Some non-matching search terms")
      .waitForElementVisible(ns+empty_list, "list should display after click ")
      .click(ns + somewhere_else)
      .waitForElementNotVisible(ns+empty_list)
      .assert.valueContains(ns+combo_input, "", "input box should be empty")
      .end()

  "On keypress, visibility of nonempty list is toggled": (browser)->
    setup(browser)

    ns = ns_1275

    browser
      .click(ns+combo_input)
      .setValue(ns+combo_input, "Some non-matching search terms")
      .waitForElementVisible(ns+combo_list, "list should display after click ")
      .click(ns + somewhere_else)
      .waitForElementNotVisible(ns+combo_list)
      .assert.valueContains(ns+combo_input, "", "input box should be empty")
      .end()

  "On typing a search term, the correct filtered list is presented": (browser)->
    setup(browser)

    ns = ns_1275

    browser
      .click(ns + combo_input)
      .setValue(ns+combo_input, "0.62")
      .waitForElementVisible(ns+combo_list, "list should become visible")
      .assert.numberOfChildren(ns+"li", 8)
      .end()

  "On arrow key navigation, only enabled items should be selectable": (browser)->
    setup(browser)

    ns = ns_1275

    browser
      .click(ns + combo_input)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .waitForElementVisible(ns+combo_list, "list should become visible")
      .pause(10)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .pause(10)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .pause(10)
      .setValue(ns+combo_input, browser.Keys.ENTER)
      .pause(10)
      .assert.visible(ns+combo_list, "list should remain visible if enter on disabled item")
      .assert.valueContains(ns+combo_input, "", "input box should remain empty")
      .setValue(ns+combo_input, browser.Keys.UP_ARROW)
      .pause(10)
      .setValue(ns+combo_input, browser.Keys.ENTER)
      .waitForElementNotVisible(ns+combo_list, "list should become hidden")
      .assert.valueContains(ns+combo_input,
        "my special number is 0.621", "item should have been selected")
      .assert.cssClassPresent(ns+second_item, "active")
      .end()

  "On item click, only enabled items should be selectable": (browser)->
    setup(browser)

    ns = ns_1275

    browser
      .click(ns+combo_button)
      .assert.cssClassPresent(ns+first_item, "disabled", "should be disabled")
      .click(ns+first_item)
      .assert.valueContains(ns+combo_input, "", "should not select clicked item if disabled")
      .assert.visible(ns+combo_list, "list should remain visible on disabled item click")
      .assert.cssClassPresent(ns+second_item, "enabled", "should be enabled")
      .click(ns+second_item)
      .assert.valueContains(ns+combo_input, "my special number is 0.621", "should select clicked item if enabled")
      .waitForElementNotVisible(ns+combo_list, "list should not remain visible on enabled item click")
      .end()

  "FilteredList, should display matched subtext in bold": (browser) ->
    setup(browser)

    ns = ns_1275

    browser
      .setValue(ns+combo_input, "massiv 12 50 0.14")
      .waitForElementVisible(ns+combo_input, "list should become visible")
      .assert.numberOfChildren(ns+"li", 2)
      .assert.innerHTML(ns+first_item,
        "<b>Massiv</b> ydervæg, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .assert.innerHTML(ns+first_item,
        "<b>Massiv</b> væg mod uopvarmet rum, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .end()


  "Selected item should be marked on list reopen": (browser) ->
    setup(browser)

    ns = ns_1275

    browser
      .click(ns + combo_button)
      .click(ns + second_item)
      .waitForElementNotVisible(ns+combo_list, "list should be hidden")
      .click(ns + combo_button)
      .assert.visible(ns+combo_list, "list should be visible")
      .assert.cssClassPresent(ns+second_item, "active")
      .end()

require("../testUtils.js").run_only(module, -3,-5)
