require('../../testutils.js').plug_macros()

module.exports =
  # MWF MACHINE
  #
  # Firefox: filter: 6362 -> 6767
  # Chrome : filter: 6168 -> 6130
  # Ie     : filter: 9643 -> 8853
  #

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
          "> time to type and filter list was ~#{time} ms" # 4994 on AHL machine
      )
      .assert.numberOfChildren(ns + combo_list + "li", 5000)
      .end()