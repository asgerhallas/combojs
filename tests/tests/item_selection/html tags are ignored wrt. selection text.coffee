require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =

  "Html tags are ignored wrt. selection text": (browser) ->
    browser
      .setupCombo()
      .click(ns + combo_input)
      .setValue(ns+combo_input, "truly")
      .assert.innerHTML(ns + combo_list + "li:nth-child(2)", "I <em><b>truly</b></em> believe you are special! <strike>#2</strike>")
      .click(ns + combo_list + "li:nth-child(2)")
      .assert.value(ns + combo_input, "I truly believe you are special! #2")
      .end()
