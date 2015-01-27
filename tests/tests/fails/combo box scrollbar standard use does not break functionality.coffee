require('../../testutils.js').plug_macros()

ns = ns_1275
module.exports =
# moveToElement seems to not change mouse position if called multiple times
# unless element is changed?

"Setup": (browser) ->
  browser.setupCombo()

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
  # browser
  # buttons are ~18 x 18px, scrollwindow is 520 x 300px
  clickScrollbarDown(browser, 5, "down")
    .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')

"Move two pages up by clicking on scrollbar": (browser) ->
  clickScrollbarDown(browser, 2, "up")
    .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')

"Move two pages down by clicking on button": (browser) ->
  clickScrollbarDown(browser, 2, "buttonDown")
    .assert.elementHasFocus(ns + combo_input, 'input field should retain focus')

"Move two pages up by clicking on button": (browser) ->
  clickScrollbarDown(browser, 2, "buttonUp")
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

#====================================================
# SUBROUTINES
#====================================================
clickScrollbarDown = (browser, clicks, direction) ->
browserName = browser.options.desiredCapabilities.browserName
isIE = "ie" is browserName
isFirefox = "firefox" is browserName
isChrome = "chrome" is browserName

yScrollbar = 540
xScrollbarDown = 200
xScrollbarUp = 20
xScrollbarButtonUp = 2
xScrollbarButtonDown = 298

x = null
switch direction
  when "down"
    x = xScrollbarDown
  when "up"
    x = xScrollbarUp
  when "buttonDown"
    x = xScrollbarButtonDown
  when "buttonUp"
    x = xScrollbarButtonUp
  else throw new Error("wrong direction argument")

# ie: more than two clicks tricks ie to release mouse position
# firefox: require moveToElement to be called at least every second time
console.log "direction", direction, x
browser.moveToElement('css selector', ns + combo_list, yScrollbar, x)
for unused in [0...clicks]
  browser
    .pause(200)
    .mouseButtonDown()
    .mouseButtonUp()
    .pause(200)
  if isFirefox
    browser.moveToElement('css selector', ns + combo_list, yScrollbar, x)
browser

#====================================================