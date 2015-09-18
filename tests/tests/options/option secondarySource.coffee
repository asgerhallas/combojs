utils = require('../../testutils.js')
utils.plug_macros()


data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [2..100]) 

ns = "#temp_combo "
module.exports =

  tags: ['secondarySource']

  "Option secondarySource: default=[]": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .assert.cssClassNotPresent('#temp_combo > div > ul > li', 'secondary-source')
      .end()

  "Option secondarySource: [{text: foo}]": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {secondarySource: [{text: 'foo'}]})
      .assert.cssClassPresent('#temp_combo > div > ul > li.secondary-source.enabled', 'secondary-source')
      .assert.innerHTML('#temp_combo > div > ul > li.secondary-source.enabled', "foo")
      .end()
      
   "Option secondarySource: null": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, {secondarySource: null})
      .assert.cssClassNotPresent('#temp_combo > div > ul > li', 'secondary-source')
      .end()