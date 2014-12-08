setup = (browser) ->
  browser
    .url("file:///C:/workspace/combojs/tests/index.html")


ignore_all_but = (start, end) ->
  e = module.exports
  ks = Object.keys(e)
  if not start? then start = ks.length-1
  if not end? then end = start

  fst = if start < 0 then ks.length+start else start
  lst = if end < 0 then ks.length+end else end

  console.log "running narrowed set of set cases: case #{fst} to #{lst}"
  module.exports = {}
  for i in [fst..lst]
    key = ks[i]
    module.exports[key] = e[key]

button_selector = 'button.combo-button'
input_selector = "input.combo-input"
list_selector = "ul.combo-list"
first_list_item = "li:nth-child(1)"
second_list_item = "li:nth-child(2)"

ns_empty = "#wrapper-test-1 "
ns_1275 = "#wrapper-test-2 "
ns_10000 = "#wrapper-test-3 "

module.exports =

  "Check initial dom element visibility": (browser)->
    setup browser

    for ns in [ns_empty, ns_1275, ns_10000]
      browser
        .waitForElementVisible('body', 5000)
        .assert.visible(ns+".combo-button")
        .assert.visible(ns+".combo-container")
        .assert.visible(ns+".combo-input-container")
        .assert.visible(ns+".combo-input")
        .assert.visible(ns+".combo-button")
        .assert.hidden(ns+".combo-list-container")
        .assert.hidden(ns+".combo-list")

    browser
      .end()

  "Check injection of testdata": (browser) ->
    setup browser
      .assert.numberOfChildren(ns_empty+"li", 0, "should be an empty list")
      .assert.numberOfChildren(ns_1275+"li", 1275, "should contain 1275 items")
      .assert.numberOfChildren(ns_10000+"li", 10000, "should contain 10000 items")
      .end()


  "On button click, list should become visible": (browser)->
    setup browser

    ns = '#wrapper-test-1 '
    browser
      .click(ns+ button_selector)
      .assert.containsText(ns+".empty-list", "(ingen valgmuligheder)")
      .waitForElementVisible(ns+list_selector)

    ns = '#wrapper-test-2 '
    browser
      .waitForElementNotVisible(ns+list_selector, "list should be hidden before click")
      .click(ns+button_selector)
      .waitForElementVisible(ns+list_selector, "list should display after click")
      .click(ns+button_selector)
      .waitForElementNotVisible(ns+list_selector, "list should be hidden on second click")
      .end()


  "On typing, list should become visible": (browser)->
    setup browser

    ns = '#wrapper-test-1 '
    browser
      .click(ns+input_selector)
      .setValue(ns+input_selector, "What would happen if I type here?")
      .assert.containsText(ns+'.empty-list', "(ingen valgmuligheder)")
      .click(ns+"h3")
      .waitForElementNotVisible(ns+".empty-list")

    browser
      .click(ns+input_selector)
      .setValue(ns+input_selector, "What would happen if I type here?")
      .waitForElementVisible(ns+list_selector, "list should display after click ")
      .assert.numberOfChildren(ns+"li", 0, "options list should be empty if nothing matches")
      .click(ns+"h3")
      .waitForElementNotVisible(ns+list_selector)
      .end()


  "On item click, items should be selectable only if enabled": (browser)->
    setup browser

    ns = '#wrapper-test-2 '

    browser
      .click(ns+button_selector)
      .assert.cssClassPresent(ns+first_list_item, "disabled", "should be disabled")
      .click(ns+first_list_item)
      .assert.containsText(ns+input_selector, "", "should not select clicked item if disabled")
      .assert.visible(ns+list_selector, "list should remain visible on disabled item click")

    browser
      .click(ns+button_selector)
      .assert.cssClassPresent(ns+second_list_item, "enabled", "should be enabled")
      .click(ns+first_list_item)
      .assert.containsText(ns+input_selector, "", "should  select clicked item if enabled")
      .waitForElementNotVisible(ns+list_selector, "list should not remain visible on enabled item click")
      .end()


  "On keypress, filtered list should be displayed": (browser)->
    setup browser

    ns = '#wrapper-test-2 '

    browser
      .click(ns + input_selector)
      .setValue(ns+input_selector, "0.62")
      .waitForElementVisible(ns+list_selector, "list should become visible")
      .assert.numberOfChildren(ns+"li", 8)
      .end()

  "Arrow key navigation, filtered list should be displayed": (browser)->
    setup browser

    ns = '#wrapper-test-2 '

    browser
      .click(ns + input_selector)
      .setValue(ns+input_selector, "massiv 12 50")
      .setValue(ns+input_selector, browser.Keys.ARROW_DOWN)
      .waitForElementVisible(ns+list_selector, "list should become visible")
      .setValue(ns+input_selector, browser.Keys.ARROW_DOWN)
      .setValue(ns+input_selector, browser.Keys.ARROW_DOWN)
      .setValue(ns+input_selector, browser.Keys.ARROW_UP)
      .setValue(ns+input_selector, browser.Keys.ENTER)
      .assert.valueContains(ns+input_selector,
        "Massiv ydervæg, 12 cm tegl, 150 mm indvendig isolering.  (U: 0.27)")
      .end()

  "FilteredList, should display matched in bold": (browser) ->
    setup browser

    ns = '#wrapper-test-2 '

    browser
      .setValue(ns+input_selector, "massiv 12 50 0.14")
      .waitForElementVisible(ns+input_selector, "list should become visible")
      .assert.numberOfChildren(ns+"li", 2)
      .assert.innerHTML(ns+first_list_item,
        "<b>Massiv</b> ydervæg, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .assert.innerHTML(ns+first_list_item,
        "<b>Massiv</b> væg mod uopvarmet rum, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .end()


  "Selected item should be marked on list reopen": (browser) ->
    browser
      .click(ns + input_selector)
      .setValue(ns+input_selector, browser.Keys.ARROW_DOWN)
      .setValue(ns+input_selector, browser.Keys.ARROW_DOWN)
      .setValue(ns+input_selector, browser.Keys.ENTER)
      .assert.hidden(ns+list_selector, "list should be hidden")
      .click(ns + button_selector)
      .assert.visible(ns+list_selector, "list should be visible")
      .assert.valueContains(ns+input_selector,
        "Massiv ydervæg, Bindingsværk, 100 mm..  (U: 0.34)",
        "item value should be displayed as selected")
      .assert.cssClassPresent(ns+first_list_item, 'active')
      .assert.cssClassPresent(ns+first_list_item, 'selected')

      .click(ns+"h3")
      .waitForElementNotVisible(ns+list_selector, "list should be hidden on click somewhere else")

      .end()


# ignore_all_but(0,2)
