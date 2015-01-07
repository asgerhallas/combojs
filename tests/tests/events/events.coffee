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
      .click(ns+enabled_item)
      .click(ns+combo_button)
      .click(ns+combo_input)
      .setValue(ns+combo_input, '23')
      .setValue(ns+combo_input, browser.Keys.ENTER)
      .click(ns+somewhere_else)
      .openComboList(ns)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .setValue(ns+combo_input, browser.Keys.DOWN_ARROW)
      .click(ns+active_item)
      .click(ns+combo_input)
      .setValue(ns+combo_input, browser.Keys.ENTER)


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
    
    browser.assert.equal(
      result.value.length, expected.length, 
      "number of events #{expected.length} ok")
    
    _.map(
      result.value, (e, index) -> 
        browser.assert.equal e.name, expected[index], 
        "event #{e.name} is #{index}th")
# ====================================================