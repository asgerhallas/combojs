require('../../testutils.js').plug_macros()

module.exports =

  "Time list render large list": (browser) ->
    ns = ns_10000

    # sometimes ie will loose focus when list takes a long time
    # see inverse test 'should not fire leave event on button click', failing in regression_fails
    browserName = browser.options.desiredCapabilities.browserName
    if 'ie' is browserName then return

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