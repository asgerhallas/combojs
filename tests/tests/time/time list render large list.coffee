require('../../testutils.js').plug_macros()

module.exports =

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
          "> time to click and render list was ~#{time} ms" #2102ms on AHL machine
      )
      .end()