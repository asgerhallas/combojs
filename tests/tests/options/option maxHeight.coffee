require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "

module.exports =

  "Option maxHeight: default=300": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .openComboList(ns+" ")
      .pause(100)
      .assert.cssProperty(ns + combo_list, 'maxHeight', "300px")
      .end()

  "Option maxHeight: 200": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {maxHeight: 200})
      .openComboList(ns+" ")
      .pause(100)
      .assert.cssProperty(ns + combo_list, 'maxHeight', "200px")
      .end()