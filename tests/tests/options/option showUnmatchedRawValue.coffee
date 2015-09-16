utils = require('../../testutils.js')
utils.plug_macros()


data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['showUnmatchedRawValue']

  "Option showUnmatchedRawValue: default=false": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .setValue('#temp_combo > div > input', "some text")
      .assert.elementNotPresent('#temp_combo .unmatched-raw-value')
      .end()

  "Option showUnmatchedRawValue: showUnmatchedRawValue=true": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {showUnmatchedRawValue: true})
      #.setValue with a sentence emulates key press to fast for the combo to follow
      .click('#temp_combo > div > input')
      .pause(20)
      .keys(["t"])
      .pause(20)
      .keys(["e"])
      .pause(20)
      .keys(["x"])
      .pause(20)
      .keys(["t"])
      .assert.containsText('.unmatched-raw-value', "text")
      .end()

  "Option showUnmatchedRawValue: selects existing items on match": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {showUnmatchedRawValue: true})
      .setValue('#temp_combo > div > input', "1")
      .assert.elementNotPresent('.unmatched-raw-value')
      .end()

  "Option showUnmatchedRawValue: throws error when forceSelectionFromList is combined with showUnmatchedRawValue": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {forceSelectionFromList: true, showUnmatchedRawValue: true}, true)
      .end()