require('../../testutils.js').plug_macros()

module.exports =

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
          "> time to type and filter list was ~#{time} ms" # 354ms on AHL machine
      )
      .assert.numberOfChildren(ns + combo_list + "li", 629)
      .end()