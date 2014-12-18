require('../testutils.js').plug_macros()

module.exports =

  "Time pause 2050 seconds takes ~2050 seconds": (browser) ->
    browser
      .assert.timer(
        (done) =>
          browser
            .pause(2050, done)
        ,
        (time) =>
          "> pausing 2050 seconds took #{time} ms"
      )
      .end()

  "Time list render medium list": (browser) ->
    ns = ns_1275

    browser
      .setupCombo()
      .assert.hidden(ns+combo_list)
      .assert.timer(
        (done) =>
          browser
            .click(ns + combo_button)
            .waitForElementVisible(ns+combo_list, done)
        ,
        (time) =>
          "> time to click and render list was ~#{time} ms"
      )
      .end()

  "Time list render large list": (browser) ->
    ns = ns_10000

    browser
      .setupCombo()
      .assert.hidden(ns+combo_list)
      .assert.timer(
        (done) =>
          browser
            .click(ns + combo_button)
            .waitForElementVisible(ns+combo_list, done)
        ,
        (time) =>
          "> time to click and render list was ~#{time} ms"
      )
      .end()

  "Time to filter medium list": (browser) ->
    ns = ns_1275

    browser
      .setupCombo()
      .click(ns + combo_input)
      .waitForElementNotVisible(ns+combo_list)
      .assert.timer(
        (done) =>
          browser
            .setValue(ns+combo_input, "badger")
            .waitForElementVisible(ns+combo_list, done)
        ,
        (time) =>
          "> time to type and filter list was ~#{time} ms"
      )
      .assert.numberOfChildren(ns + combo_list + "li", 629)
      .end()

  "Time to filter large list": (browser) ->
    ns = ns_10000

    browser
      .setupCombo()
      .click(ns + combo_input)
      .waitForElementNotVisible(ns+combo_list)
      .assert.timer(
        (done) =>
          browser
            .setValue(ns+combo_input, "badger")
            .waitForElementVisible(ns+combo_list, done)
        ,
        (time) =>
          "> time to type and filter list was ~#{time} ms"
      )
      .assert.numberOfChildren(ns + combo_list + "li", 5000)
      .end()

# require("../testUtils.js").run_only(module, -1)
