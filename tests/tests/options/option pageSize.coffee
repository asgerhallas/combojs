require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =

  "Option pageSkip: default=10": (browser) ->
    pageskip = 10 # default value
    browser.setupCombo()
    browser.newComboElement(ns, data)
    testPageSkip(browser, ns, pageskip)
    browser.end()

  "Option pageSkip: 20": (browser) ->
    pageskip = 20
    browser.setupCombo()
    browser.newComboElement(ns, data, {pageSize: pageskip})
    testPageSkip(browser, ns, pageskip)
    browser.end()

#====================================================
# SUBROUTINES
#====================================================
testPageSkip = (browser, ns, pageskip) ->
  browser.openComboList(ns)

  for i in [1..3]
    skip = i*pageskip+1

    browser
      .setValue(ns + combo_input, browser.Keys.PAGEDOWN)
      .pause(10)
      .assert.cssClassPresent(
        ns + "li:nth-child(#{skip})", 'active',
        "the #{skip}th item is active")
      .assert.cssClassNotPresent(
        ns + "li:nth-child(#{skip+1})", 'active',
        "the #{skip+1}th item is not active")

  for j in [1..2]
    skip = 3*pageskip+1 - j*pageskip
    browser
      .setValue(ns + combo_input, browser.Keys.PAGEUP)
      .pause(10)
      .assert.cssClassPresent(
        ns + "li:nth-child(#{skip})",
        'active', "the #{skip}th item is active")
      .assert.cssClassNotPresent(
        ns + "li:nth-child(#{skip+1})",
        'active', "the #{skip+1}th item is not active")
#====================================================