require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", valid: i%2 != 0 } for i in [1..100])

ns = "#temp_combo "
comboId = "last"
module.exports =

  tags: ["enabledField"]

  "Option enabledField: default='true'": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .assert.numberOfChildren(ns + combo_list+"li", 100)
      .assert.cssClassPresent(ns + first_item, 'enabled')
      .assert.cssClassPresent(ns + second_item, 'enabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .end()

  "Option enabledField: 'valid'": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, { enabledField: 'valid' })
      .assert.cssClassPresent(ns + first_item, 'enabled')
      .assert.cssClassPresent(ns + second_item, 'disabled')
      .assert.cssClassPresent(ns + third_item, 'enabled')
      .assert.numberOfChildren(ns + combo_list+"li", 100)
      .end()
