utils = require('../../testutils.js')
utils.plug_macros()


data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['emptyFieldValidation']

  "Option emptyFieldValidation: default=false": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .setValue('#temp_combo > div > input', "")
      .assert.cssClassNotPresent('#temp_combo > div > input', 'empty')
      .end()

  "Option emptyFieldValidation: true": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {emptyFieldValidation: true})
      #It is necessary to sent a key to trigger "keyup"
      .setValue('#temp_combo > div > input', ["", browser.Keys.ENTER])
      .assert.cssClassPresent('#temp_combo > div > input', 'empty')
      .end()
