require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", potato: i%2 != 0, true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  "Option onlyShowEnabled: default=disabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .assert.cssClassPresent(ns + first_item, 'disabled')
      .assert.cssClassPresent(ns + second_item, 'disabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .assert.numberOfChildren(ns + combo_list+"li", 100)
      .end()

  "Option onlyShowEnabled: enabled": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { onlyShowEnabled: yes})
      .assert.cssClassPresent(ns + first_item, 'enabled')
      .assert.cssClassPresent(ns + second_item, 'enabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .assert.numberOfChildren(ns + combo_list+"li", 33)
      .end()


