utils = require('../../testutils.js')
utils.plug_macros()

# labelFunc = (item, rawValue) ->
#   if item isnt null
#     return {text: "Bob Reggae", className: "foo"}   
#   return null

data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['label']

  "Option label: () -> {text: Bob Reggae, className: foo})": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {label: (item, rawValue) => return {text: "Bob Reggae", className: "foo"}})
      .openComboList(ns)
      .pause(5000)
      .assert.containsText('.foo', "Bob Reggae")
      .click(ns+third_item)
      .assert.containsText('.foo', "Bob Reggae")
      .end()
