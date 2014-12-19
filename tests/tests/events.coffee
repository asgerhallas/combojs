require('../testutils.js').plug_macros()
_ = require('underscore')

module.exports =

  "Can access combo controller": (browser) ->
    browser
      .setupCombo()
      .execute(
        ( -> Object.keys(controllers)), [],
        (result) ->
          browser.assert.ok result.status is 0, "status ok"
          expected = [ns_empty, ns_1275, ns_10000]
          browser.assert.equal ns_empty, result.value[0]
          browser.assert.equal ns_1275, result.value[1]
          browser.assert.equal ns_10000, result.value[2]
      )
      .end()

  "item select triggers select event": (browser) ->
    ns = ns_1275

    getEvents = (ns) -> events[ns]

    checkEventsWrapper = (expected) ->
      (result) ->
        names = _.map(result.value, (e) -> e.name)
        console.log names
        browser.assert.equal result.status, 0, 'check status'
        browser.assert.equal result.value.length, expected.length, "check number of events #{expected.length}"
        _.map(names, (name, index) -> browser.assert.equal name, expected[index], "event #{name} should be #{index}th")

    browser
      .setupCombo()
      .execute getEvents, [ns], checkEventsWrapper(['loaded'])
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
      .execute getEvents, [ns],
        checkEventsWrapper(
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


require("../testUtils.js").run_only(module, -1)
