require('../../testutils.js').plug_macros()

ns = ns_1275
module.exports =

  "Setup": (browser) ->
    browser
      .setupCombo()
      .execute getEvents, [ns], checkEventsWrapper(browser, ['loaded'])

  "Fire events": (browser) ->
    browser
      .click(ns+combo_button)
      .pause(100)
      .click(ns+enabled_item)
      .pause(100)
      .click(ns+combo_button)
      .pause(100)
      .setValue(ns+combo_input, '23')
      .pause(100)
      .setValue(ns+combo_input, browser.Keys.ENTER)
      .pause(100)
      .click(ns+somewhere_else)
      .pause(100)
      .openComboList(ns)
      .pause(100)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .pause(100)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .pause(100)
      .click(ns+active_item)
      .pause(100)
      .click(ns+combo_input)
      .pause(100)
      .setValue(ns+combo_input, browser.Keys.ENTER)
      .pause(100)


  "Check events": (browser) ->
    browser
      .execute getEvents, [ns],
        checkEventsWrapper(
          browser,
          ['loaded',
           'enter',
           'focus',
           'enter',
           'focus',
           'itemSelect',
           'enter',
           'focus',
           'itemSelect'
           'leave',
           'enter',
           'focus',
           'enter',
           'focus',
           'itemSelect',
           'enterpress'])
      .end()


#====================================================
# SUBROUTINES
#====================================================
getEvents = (ns) -> events[ns]

checkEventsWrapper = (browser, expected) ->
  (result) ->
    browser.assert.equal(
      result.status, 0,
      'status ok')

    for event in result.value
      console.log JSON.stringify(event)

    browser.assert.equal(
      expected.length, result.value.length
      "number of events #{expected.length} ok")

    _.map(
      result.value, (e, index) ->
        browser.assert.equal e.name, expected[index],
        "event #{e.name} is #{index}th")
# ====================================================