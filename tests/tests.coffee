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
  "Check initial dom element visibility and data injection": (browser)->
    ns = ns_empty
    setup(browser)
      .waitForElementVisible('body', 5000)
      .assert.visible(ns+".combo-button")
      .assert.visible(ns+".combo-container")
      .assert.visible(ns+".combo-input-container")
      .assert.visible(ns+".combo-input")
      .assert.visible(ns+".combo-button")
      .assert.hidden(ns+".combo-list-container")
      .assert.hidden(ns+".combo-list")
      .assert.numberOfChildren(ns+"li", 0, "should be an empty list")

      ns = ns_1275
      browser
      .waitForElementVisible('body', 5000)
      .assert.visible(ns+".combo-button")
      .assert.visible(ns+".combo-container")
      .assert.visible(ns+".combo-input-container")
      .assert.visible(ns+".combo-input")
      .assert.visible(ns+".combo-button")
      .assert.hidden(ns+".combo-list-container")
      .assert.hidden(ns+".combo-list")
      .assert.numberOfChildren(ns+"li", 1275, "should contain 1275 items")

      ns = ns_10000
      browser
      .waitForElementVisible('body', 5000)
      .assert.visible(ns+".combo-button")
      .assert.visible(ns+".combo-container")
      .assert.visible(ns+".combo-input-container")
      .assert.visible(ns+".combo-input")
      .assert.visible(ns+".combo-button")
      .assert.hidden(ns+".combo-list-container")
      .assert.hidden(ns+".combo-list")
      .assert.numberOfChildren(ns+"li", 10000, "should contain 10000 items")

      .end()



  "Empty list text should become visible on button click - test 1": (browser)->
    setup(browser)
      .click("#wrapper-test-1 button.combo-button")
      .assert.containsText("#wrapper-test-1 .empty-list", "(ingen valgmuligheder)")
      .end()

  "Empty list text should become visible on typing - test 1": (browser)->
    setup(browser)
      .click("#wrapper-test-1 input.combo-input")
      .setValue("#wrapper-test-1 input[type=text]", "What would happen if I type here?")
      .assert.containsText("#wrapper-test-1 .empty-list", "(ingen valgmuligheder)")
      .click("#wrapper-test-1 h3")
      .waitForElementNotVisible("#wrapper-test-1  .empty-list", 100)
      .end()

  "Button  click should display list": (browser)->
    ns = '#wrapper-test-2 '

    setup(browser)
      .waitForElementNotVisible(ns+list_selector, "list should be hidden before click")
      .click(ns+button_selector)
      .waitForElementVisible(ns+list_selector, "list should display after click")
      .assert.numberOfChildren(ns+"li", 1275, "should display all 1275 elements")
      .click(ns+button_selector)
      .waitForElementNotVisible(ns+list_selector, "list should be hiden on second click")
      .end()


  "Disabled items should not be selectable on button click - test 2": (browser)->
    ns = '#wrapper-test-2 '

    setup(browser)
      .click(ns+button_selector)
      .assert.cssClassPresent(ns+first_list_item, "disabled", "should be disabled")
      .click(ns+first_list_item)
      .assert.containsText(ns+input_selector, "", "should not select clicked item if disabled")
      .waitForElementVisible(ns+list_selector, "list should remain visible on disabled item click")
      .end()

  "Enabled items should be selectable on button click - test 2": (browser)->
    ns = '#wrapper-test-2 '

    setup(browser)
      .click(ns+button_selector)
      .assert.cssClassPresent(ns+second_list_item, "enabled", "should be enabled")
      .click(ns+first_list_item)
      .assert.containsText(ns+input_selector, "", "should  select clicked item if enabled")
      .waitForElementNotVisible(ns+list_selector, "list should not remain visible on enabled item click")
      .end()

  "List should be displayed on key press and selected on enter - test 2": (browser)->
    ns = '#wrapper-test-2 '

    setup(browser)
      .setValue(ns+input_selector, "0.62")
      .waitForElementVisible(ns+list_selector, "list should be visible")
      .assert.numberOfChildren(ns+"li", 8)

      .setValue(ns+input_selector, browser.Keys.ENTER)
      .assert.valueContains(ns+input_selector,
        "Massiv ydervæg, 12 cm tegl, 50 mm indvendig isolering.  (U: 0.62)",
        "item value should be displayed as selected")
      .assert.hidden(ns+list_selector, "list should be hidden")

      .click(ns+button_selector)
      .assert.cssClassPresent(ns+"li:nth-child(6)", 'active')
      .assert.cssClassPresent(ns+"li:nth-child(6)", 'selected')

      .click(ns+"h3")
      .waitForElementNotVisible(ns+list_selector, "list should be hidden on click somewhere else")

      .end()

  "Items should be filterable and first matches rendered in bold - test 2": (browser)->
    ns = '#wrapper-test-2 '

    browser.assert.equal(2,3)

    setup(browser)
      .click(ns + '.combo-input')
      .setValue(ns+'.combo-input', "massiv 12 50 0.14")
      .waitForElementVisible(ns+"input:first-child")
      .assert.valueContains(ns+".combo-input", "massiv 12 50 0.14")
      .assert.numberOfChildren(ns+"ul.combo-list", 2)
      .assert.innerHTML(ns+"li:nth-child(1)",
        "<b>Massiv</b> ydervæg, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .assert.innerHTML(ns+"li:nth-child(2)",
        "<b>Massiv</b> ydervæg, <b>12</b> cm tegl, 2<b>50</b> mm udvendig isolering.  (U: <b>0.14</b>)")
      .end()


ignore_all_but(0)
