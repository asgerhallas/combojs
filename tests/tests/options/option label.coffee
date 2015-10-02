utils = require('../../testutils.js')
utils.plug_macros()
data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['label']

  "Option label: () -> {text: Bob Reggae, className: foo})": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .execute(
        () =>
          combo = $("#temp_combo .combo_wrapper").data('combo')
          combo.label = () => return {text: "Bob Reggae", className: "foo"})
      .openComboList(ns)
      .assert.containsText('.foo', "Bob Reggae")
      .click(ns+third_item)
      .assert.containsText('.combo_wrapper > .foo', "Bob Reggae")
      .end()
