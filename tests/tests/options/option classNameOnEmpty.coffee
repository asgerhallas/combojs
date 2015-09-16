utils = require('../../testutils.js')
utils.plug_macros()


data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['classNameOnEmpty']

  "Option classNameOnEmpty: default=false": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .setValue('#temp_combo > div > input', "")
      .assert.cssClassNotPresent('#temp_combo > div > input', 'empty')
      .end()

  "Option has class 'empty' at construction time classNameOnEmpty: true": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {classNameOnEmpty: 'empty'})
      .assert.cssClassPresent('#temp_combo > div > input', 'empty')
      .end()

  "Option has class 'empty' after delete of text in input classNameOnEmpty: true": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {classNameOnEmpty: 'empty'})
      .setValue('#temp_combo > div > input', "some text")
      .assert.cssClassNotPresent('#temp_combo > div > input', 'empty')
      .clearValue('#temp_combo > div > input')
      .setValue('#temp_combo > div > input', [browser.Keys.ENTER]) #a key hit is needed to trigger onKeyUp
      .assert.cssClassPresent('#temp_combo > div > input', 'empty')
      .end()
