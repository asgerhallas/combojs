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

  "Option minLength": (browser) ->
    ns = ns_1275

    remoteLoad = (ns) -> controllers[ns].minLength = 5

    browser
      .setupCombo()
      .setValue(ns+combo_input, "pre")
      .assert.numberOfChildren(ns+combo_list+"li", 2)

      .refresh()
      .execute remoteLoad, [ns]
      .setValue(ns+combo_input, 'pref')
      .verify.numberOfChildren(ns+combo_list+"li", 0)
      .setValue(ns+combo_list, 'i')
      .verify.numberOfChildren(ns+combo_list+"li", 2)
      .end()

  "Option expandOnFocus": (browser) ->
    ns = ns_1275

    remoteLoad = (ns) -> controllers[ns].expandOnFocus = true

    checkRemote = (result) ->
      browser.assert.equal result.status, 0

    browser
      .setupCombo()
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .pause(1000)
      .assert.hidden(ns+combo_list)

      .refresh()
      .execute remoteLoad, [ns], checkRemote
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .waitForElementVisible(ns+combo_list)
      .end()

  "Option allowEmpty": (browser) ->
    ns = ns_1275

    # TODO: refactor to reinitialize combobox from skratch?
    remoteLoad = (ns) ->
      controllers[ns].allowEmpty = true
      controllers[ns].load [{id: i++, text: "my special number is 0.620", true: false}]

    checkRemote = (result) ->
      browser.assert.equal result.status, 0

    browser
      .setupCombo()
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .pause(1000)
      .assert.hidden(ns+combo_list)

      .refresh()
      .execute remoteLoad, [ns], checkRemote
      .assert.hidden(ns+combo_list)
      .click(ns+combo_input)
      .waitForElementVisible(ns+combo_list)
      .end()


require("../testUtils.js").run_only(module, -1)
