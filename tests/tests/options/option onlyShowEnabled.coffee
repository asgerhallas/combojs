require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", enabled: i%2 != 0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ["onlyShowEnabled"]

  "Option onlyShowEnabled: default=false": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { enabledField: (x) -> x.enabled})
      .assert.cssClassPresent(ns + first_item, 'enabled')
      .assert.cssClassPresent(ns + second_item, 'enabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .assert.numberOfChildren(ns + combo_list+"li", 100)
      .end()

  "Option onlyShowEnabled: true": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { onlyShowEnabled: yes, enabledField: "enabled" })
      .assert.cssClassPresent(ns + first_item, 'enabled')
      .assert.cssClassPresent(ns + second_item, 'enabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .assert.numberOfChildren(ns + combo_list+"li", 50)
      .end()


